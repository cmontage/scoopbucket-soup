# If invoked during scoop update, do not perform uninstallation cleanup!
if ($cmd -eq 'update' -or ((Get-PSCallStack | Select-Object -ExpandProperty ScriptName) -match 'scoop-update\.ps1')) {
    return
}

# Only proceed when actually uninstalling (scoop uninstall)
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Warning "`nuuyc uninstall cleanup requires administrator privileges.`nSkipping privileged cleanup.`n"
    return
}

# Stop and remove service
Stop-Service -Name 'GameViewerService' -Force -ErrorAction SilentlyContinue
& sc.exe delete 'GameViewerService' | Out-Null

# Safely remove junctions so persistent data in $persist_dir is preserved
Remove-Junction "$env:LOCALAPPDATA\GameViewer" -ErrorAction SilentlyContinue | Out-Null
Remove-Junction "$env:ProgramData\Netease\GameViewer" -ErrorAction SilentlyContinue | Out-Null

# Clean up scheduled tasks
Get-ScheduledTask -TaskName '*GameViewer*' -ErrorAction SilentlyContinue | Unregister-ScheduledTask -Confirm:$false -ErrorAction SilentlyContinue
Get-ScheduledTask -TaskName '*UU*' -ErrorAction SilentlyContinue | Unregister-ScheduledTask -Confirm:$false -ErrorAction SilentlyContinue

$localPaths = @(
    "$env:WINDIR\system32\config\systemprofile\AppData\Local\GameViewer"
)

$userSID = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
$registryPaths = @(
    'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\GameViewerService'
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Netease'
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Netease"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\GameViewer"
)

$sidRoots = Get-ChildItem Registry::HKEY_USERS -ErrorAction SilentlyContinue | Where-Object { $_.PSChildName -match '^S-1-5-21-(\d+-){3}\d+$' } | ForEach-Object { $_.PSPath }
foreach ($sid in $sidRoots) {
    $registryPaths += "$sid\SOFTWARE\Netease"
    $registryPaths += "$sid\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\GameViewer"
}

$paths = @(
    "$dir\GameViewer\GameViewer.exe"
    "$($dir -replace '\\[^\\]+$', '\current')\GameViewer\GameViewer.exe"
    'D:\Apps\Software-NP\Netease\Gameviewer\GameViewer.exe'
)
$registryValues = @(
    "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run|GameViewer"
)
foreach ($sid in $sidRoots) {
    $registryValues += "$sid\SOFTWARE\Microsoft\Windows\CurrentVersion\Run|GameViewer"
    $registryValues += "$sid\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\UserAssist\{CEBFF5CD-ACE2-4F4F-9178-9926F41749EA}\Count|Q:\Nccf\Fbsgjner-AC\Argrnfr\Tnzrivrjre\ova\TnzrIvrjre.rkr"
    $registryValues += "$sid\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\UserAssist\{CEBFF5CD-ACE2-4F4F-9178-9926F41749EA}\Count|Q:\Nccf\Fbsgjner-AC\Argrnfr\Tnzrivrjre\TnzrIvrjre.rkr"
    foreach ($p in $paths) {
        $registryValues += "$sid\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store|$p"
    }
}

Remove-AppData -LocalPaths $localPaths -RegistryPaths $registryPaths -RegistryValues $registryValues
