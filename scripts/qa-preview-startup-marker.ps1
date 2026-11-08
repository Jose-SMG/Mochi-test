# Inspect native HWND visibility, including hidden windows. A screenshot cannot
# distinguish an intentionally hidden marker from a visible window parked away.
param([Parameter(Mandatory=$true)][int]$AppProcessId)
$ErrorActionPreference = 'Stop'
Add-Type -TypeDefinition @'
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;
public static class PreviewMarkerWindows {
    private delegate bool EnumProc(IntPtr window, IntPtr data);
    [DllImport("user32.dll")] private static extern bool EnumWindows(EnumProc callback, IntPtr data);
    [DllImport("user32.dll")] private static extern uint GetWindowThreadProcessId(IntPtr window, out uint process);
    [DllImport("user32.dll", CharSet=CharSet.Unicode)] private static extern int GetWindowText(IntPtr window, StringBuilder text, int length);
    [DllImport("user32.dll")] private static extern bool IsWindowVisible(IntPtr window);
    public static bool[] Find(int process, string expectedTitle) {
        var result = new List<bool>();
        EnumWindows((window, data) => {
            uint owner;
            GetWindowThreadProcessId(window, out owner);
            if (owner != process) return true;
            var title = new StringBuilder(256);
            GetWindowText(window, title, title.Capacity);
            if (title.ToString() == expectedTitle) result.Add(IsWindowVisible(window));
            return true;
        }, IntPtr.Zero);
        return result.ToArray();
    }
}
'@
$Deadline = (Get-Date).AddSeconds(30)
do {
    $Markers = @([PreviewMarkerWindows]::Find($AppProcessId, 'Mochi edge indicator'))
    if ($Markers.Count -gt 0) { break }
    Start-Sleep -Milliseconds 200
} while ((Get-Date) -lt $Deadline)
if ($Markers.Count -ne 1) { throw "Expected one native edge indicator after startup, found $($Markers.Count)" }
for ($Sample = 0; $Sample -lt 20; $Sample++) {
    $Markers = @([PreviewMarkerWindows]::Find($AppProcessId, 'Mochi edge indicator'))
    if ($Markers.Count -ne 1 -or $Markers[0]) { throw 'Edge indicator must remain natively hidden until a valid drag target exists' }
    Start-Sleep -Milliseconds 100
}
$Branded = @([PreviewMarkerWindows]::Find($AppProcessId, 'Coucou'))
if ($Branded.Count -lt 1) { throw 'The installed app must expose the requested Coucou window title' }
Write-Host 'Native edge indicator exists and stays hidden at cold start.'
Write-Host 'Native application window title is Coucou.'
