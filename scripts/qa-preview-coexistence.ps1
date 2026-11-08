# Native installation/launch/uninstall check on a disposable Windows CI machine.
param([Parameter(Mandatory=$true)][string]$Installer)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
if ($env:GITHUB_ACTIONS -ne 'true') { throw 'This test writes official-app sentinels and is restricted to disposable GitHub runners.' }
$Out = Join-Path $PSScriptRoot '../build/coexistence'
New-Item -ItemType Directory $Out -Force | Out-Null
$Sandbox = Join-Path $env:RUNNER_TEMP 'mochi-preview-coexistence'
$Target = Join-Path $Sandbox 'installed-preview'
$FakeHome = Join-Path $Sandbox 'home'
$FakeRoaming = Join-Path $Sandbox 'roaming'
$Official = @(
    (Join-Path $env:LOCALAPPDATA 'Coucou/bin/coucou-hook.exe'),
    (Join-Path $env:LOCALAPPDATA 'Coucou/inbox/official-session.json'),
    (Join-Path $env:LOCALAPPDATA 'Coucou/coucou.log'),
    (Join-Path $env:LOCALAPPDATA 'Programs/Coucou/coucou.exe'),
    (Join-Path $FakeRoaming 'Coucou/settings.json'),
    (Join-Path $FakeHome '.claude/settings.json')
)
foreach ($Path in $Official) {
    if (Test-Path $Path) { throw "Expected a clean CI machine: $Path already exists" }
    New-Item -ItemType Directory (Split-Path -Parent $Path) -Force | Out-Null
    '{"hooks":{"Stop":[{"command":"C:\\Coucou\\bin\\coucou-hook.exe"}]},"official":"must survive"}' | Set-Content $Path -Encoding utf8
}
$Hashes = @{}; foreach ($Path in $Official) { $Hashes[$Path] = (Get-FileHash $Path).Hash }
$OfficialRegistration = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\Coucou'
if (Test-Path $OfficialRegistration) { throw 'Expected a clean official Coucou registry namespace' }
New-Item $OfficialRegistration -Force | Out-Null
New-ItemProperty $OfficialRegistration -Name DisplayName -Value 'Coucou' -Force | Out-Null
New-ItemProperty $OfficialRegistration -Name OriginalSentinel -Value 'must survive' -Force | Out-Null
$StartupRegistry = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run'
New-Item $StartupRegistry -Force | Out-Null
New-ItemProperty $StartupRegistry -Name Coucou -Value 'official-startup-sentinel' -Force | Out-Null
$OldProfile = $env:USERPROFILE; $OldAppData = $env:APPDATA
$Report = @{passed=$false; source_commit=$env:GITHUB_SHA; product='Coucou'; checks=@()}
try {
    $env:USERPROFILE=$FakeHome; $env:APPDATA=$FakeRoaming
    # Keep LOCALAPPDATA unchanged so the runner's WebView2 runtime can be found.
    $PreviousInstaller = Join-Path $Sandbox 'previous-setup.exe'
    Invoke-WebRequest 'https://github.com/Jose-SMG/Mochi-test/releases/download/coucou-community-v0.1.1-beta.1/Coucou-Community-0.1.1-beta.1-Windows-x64-setup.exe' -OutFile $PreviousInstaller
    if ((Get-FileHash $PreviousInstaller -Algorithm SHA256).Hash -ne '3c38fab08838806a6c1f2c2cd922f7783068c84c1ded37e81fe1431f9bba0701') { throw 'Previous installer hash mismatch' }
    $PreviousSetup = Start-Process $PreviousInstaller -ArgumentList @('/S', "/D=$Target") -PassThru -Wait
    if ($PreviousSetup.ExitCode -ne 0) { throw 'Previous installer failed' }
    $OldExe = Join-Path $Target 'mochi-studio-preview.exe'
    if (-not (Test-Path $OldExe)) { throw 'Previous version executable not installed' }
    Get-Process mochi-studio-preview -ErrorAction SilentlyContinue | Where-Object { $_.Path -eq $OldExe } | Stop-Process -Force
    $Settings = Join-Path $FakeRoaming 'MochiStudioPreview/settings.json'
    New-Item -ItemType Directory (Split-Path -Parent $Settings) -Force | Out-Null
    '{"language":"en","autostart":true,"mochiSkin":"diamond","mochiStudio":"{\"roomStyle\":\"gamer\",\"desktopProps\":[]}"}' | Set-Content $Settings -Encoding utf8
    $Setup = Start-Process (Resolve-Path $Installer).Path -ArgumentList @('/S', "/D=$Target") -PassThru -Wait
    if ($Setup.ExitCode -ne 0) { throw "Installer failed: $($Setup.ExitCode)" }
    $Exe = Join-Path $Target 'Coucou.exe'
    if (-not (Test-Path $Exe)) { throw "Preview executable not installed at $Exe" }
    $Report.checks += 'independent executable installed'
    $Registration = Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\Coucou Community'
    $Metadata = Get-Content (Join-Path $PSScriptRoot '../mochi-preview.json') -Raw | ConvertFrom-Json
    if ($Registration.DisplayName -ne $Metadata.product_name -or $Registration.DisplayVersion -ne $Metadata.application_version) { throw 'Installer name or registered version is incorrect' }
    $Report.checks += 'Coucou installer name and version registered'
    # NSIS may start the application; shut down only this installation before the explicit launch.
    Get-Process coucou -ErrorAction SilentlyContinue | Where-Object { $_.Path -eq $Exe } | Stop-Process -Force
    if (Test-Path $OldExe) { throw 'Upgrade left the obsolete Mochi executable behind' }
    $VersionInfo = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($Exe)
    if ($VersionInfo.ProductName -ne 'Coucou') { throw 'Executable product name must be exactly Coucou' }
    $ProgramFolders = @([Environment]::GetFolderPath('Programs'), (Join-Path $FakeRoaming 'Microsoft/Windows/Start Menu/Programs'), (Join-Path $OldAppData 'Microsoft/Windows/Start Menu/Programs')) | Select-Object -Unique
    $Shell = New-Object -ComObject WScript.Shell
    $OwnedShortcuts = @($ProgramFolders | ForEach-Object { Join-Path $_ 'Coucou.lnk' } | Where-Object { (Test-Path $_) -and $Shell.CreateShortcut($_).TargetPath -eq $Exe })
    if ($OwnedShortcuts.Count -ne 1) { throw 'The Start menu must contain one Coucou shortcut to the installed executable' }
    foreach ($Folder in $ProgramFolders) {
        $Former = Join-Path $Folder 'Coucou Community.lnk'
        if ((Test-Path $Former) -and $Shell.CreateShortcut($Former).TargetPath.StartsWith($Target)) { throw 'Upgrade retained the obsolete shortcut label' }
    }
    $Saved = Get-Content $Settings -Raw | ConvertFrom-Json
    if ($Saved.mochiSkin -ne 'diamond' -or ($Saved.mochiStudio | ConvertFrom-Json).roomStyle -ne 'gamer') { throw 'Upgrade lost room or appearance preferences' }
    $Report.checks += 'upgrade replaces the previous executable and shortcut while retaining preferences'
    $Report.checks += 'executable and Start menu shortcut are named Coucou'
    $Log = Join-Path $env:LOCALAPPDATA 'MochiStudioPreview/mochi-studio-preview.log'
    $App = Start-Process $Exe -PassThru
    $Deadline = (Get-Date).AddSeconds(90)
    while (-not (Test-Path $Log) -and (Get-Date) -lt $Deadline) { Start-Sleep -Milliseconds 500; $App.Refresh(); if ($App.HasExited) { throw "Preview exited at launch: $($App.ExitCode)" } }
    if (-not (Test-Path $Log)) { throw 'Preview did not initialize its separate data directory' }
    if (-not (Test-Path $Settings)) { throw 'Separate preferences are missing' }
    Start-Sleep -Seconds 3
    $App.Refresh(); if ($App.HasExited) { throw 'Preview did not stay running' }
    $Report.checks += 'native app runs with separate preferences'
    & (Join-Path $PSScriptRoot 'qa-preview-startup-marker.ps1') -AppProcessId $App.Id
    $Report.checks += 'edge indicator exists and stays hidden at cold start'
    $Report.checks += 'native app window title is Coucou'
    $Startup = Get-ItemProperty $StartupRegistry
    if (-not ($Startup.'io.github.jose-smg.mochistudio.preview' -like "*$Exe*")) { throw 'App startup registration must use its private identity' }
    $Report.checks += 'startup registration retains its independent identity'
    $PreviewHook = Join-Path $env:LOCALAPPDATA 'MochiStudioPreview/bin/mochi-studio-preview-hook.exe'
    if (Test-Path $PreviewHook) { throw 'Disabled agent hook was installed' }
    $Report.checks += 'agent-hook installation disabled'
    Get-Process coucou -ErrorAction SilentlyContinue | Where-Object { $_.Path -eq $Exe } | Stop-Process -Force
    $Uninstaller = @(Get-ChildItem $Target -Filter '*uninstall*.exe' -File)
    if ($Uninstaller.Count -ne 1) { throw 'Preview uninstaller not found' }
    $Remove = Start-Process $Uninstaller[0].FullName -ArgumentList '/S' -PassThru -Wait
    if ($Remove.ExitCode -ne 0) { throw "Uninstall failed: $($Remove.ExitCode)" }
    # NSIS can hand off to a temporary child uninstaller before its parent exits.
    # Wait for actual removal before checking that official files survived.
    $Deadline = (Get-Date).AddSeconds(60)
    while ((Test-Path $Exe) -and (Get-Date) -lt $Deadline) { Start-Sleep -Milliseconds 250 }
    if (Test-Path $Exe) { throw 'Preview executable still exists after uninstall' }
    $Report.checks += 'independent preview executable actually removed'
    $Saved = Get-Content $Settings -Raw | ConvertFrom-Json
    if ($Saved.mochiSkin -ne 'diamond' -or ($Saved.mochiStudio | ConvertFrom-Json).roomStyle -ne 'gamer') { throw 'Removing the old preview must preserve room and appearance preferences' }
    $Report.checks += 'room and appearance preferences survive uninstall'
    foreach ($Path in $Official) {
        if (-not (Test-Path $Path) -or (Get-FileHash $Path).Hash -ne $Hashes[$Path]) { throw "Official file changed: $Path" }
    }
    $Report.checks += 'all six official app, data and Claude hook sentinels unchanged'
    if ((Get-ItemProperty $OfficialRegistration).OriginalSentinel -ne 'must survive' -or (Get-ItemProperty $StartupRegistry).Coucou -ne 'official-startup-sentinel') { throw 'Original app registry or startup registration changed' }
    $Report.checks += 'official application and startup registry values unchanged'
    $Report.passed=$true
} catch {
    $Report.error=$_.Exception.Message
    throw
} finally {
    $env:USERPROFILE=$OldProfile; $env:APPDATA=$OldAppData
    $Report | ConvertTo-Json -Depth 5 | Set-Content (Join-Path $Out 'windows-coexistence.json') -Encoding utf8
}
