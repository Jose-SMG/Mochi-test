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
$OldProfile = $env:USERPROFILE; $OldAppData = $env:APPDATA
$Report = @{passed=$false; source_commit=$env:GITHUB_SHA; product='Mochi Studio Preview'; checks=@()}
try {
    $env:USERPROFILE=$FakeHome; $env:APPDATA=$FakeRoaming
    # Keep LOCALAPPDATA unchanged so the runner's WebView2 runtime can be found.
    $Setup = Start-Process (Resolve-Path $Installer).Path -ArgumentList @('/S', "/D=$Target") -PassThru -Wait
    if ($Setup.ExitCode -ne 0) { throw "Installer failed: $($Setup.ExitCode)" }
    $Exe = Join-Path $Target 'mochi-studio-preview.exe'
    if (-not (Test-Path $Exe)) { throw "Preview executable not installed at $Exe" }
    $Report.checks += 'independent executable installed'
    # NSIS may start the application; shut down only this installation before the explicit launch.
    Get-Process mochi-studio-preview -ErrorAction SilentlyContinue | Where-Object { $_.Path -eq $Exe } | Stop-Process -Force
    $Settings = Join-Path $FakeRoaming 'MochiStudioPreview/settings.json'
    New-Item -ItemType Directory (Split-Path -Parent $Settings) -Force | Out-Null
    '{"language":"en","autostart":false}' | Set-Content $Settings -Encoding utf8
    $Log = Join-Path $env:LOCALAPPDATA 'MochiStudioPreview/mochi-studio-preview.log'
    $App = Start-Process $Exe -PassThru
    $Deadline = (Get-Date).AddSeconds(90)
    while (-not (Test-Path $Log) -and (Get-Date) -lt $Deadline) { Start-Sleep -Milliseconds 500; $App.Refresh(); if ($App.HasExited) { throw "Preview exited at launch: $($App.ExitCode)" } }
    if (-not (Test-Path $Log)) { throw 'Preview did not initialize its separate data directory' }
    if (-not (Test-Path $Settings)) { throw 'Separate preferences are missing' }
    Start-Sleep -Seconds 3
    $App.Refresh(); if ($App.HasExited) { throw 'Preview did not stay running' }
    $Report.checks += 'native app runs with separate preferences'
    $PreviewHook = Join-Path $env:LOCALAPPDATA 'MochiStudioPreview/bin/mochi-studio-preview-hook.exe'
    if (Test-Path $PreviewHook) { throw 'Disabled agent hook was installed' }
    $Report.checks += 'agent-hook installation disabled'
    Get-Process mochi-studio-preview -ErrorAction SilentlyContinue | Where-Object { $_.Path -eq $Exe } | Stop-Process -Force
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
    foreach ($Path in $Official) {
        if (-not (Test-Path $Path) -or (Get-FileHash $Path).Hash -ne $Hashes[$Path]) { throw "Official file changed: $Path" }
    }
    $Report.checks += 'all six official app, data and Claude hook sentinels unchanged'
    $Report.passed=$true
} catch {
    $Report.error=$_.Exception.Message
    throw
} finally {
    $env:USERPROFILE=$OldProfile; $env:APPDATA=$OldAppData
    $Report | ConvertTo-Json -Depth 5 | Set-Content (Join-Path $Out 'windows-coexistence.json') -Encoding utf8
}
