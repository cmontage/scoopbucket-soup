$localPaths = @(
    "$env:LOCALAPPDATA\ToDesk"
)
$userSID = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
$registryPaths = @(
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\RADAR\HeapLeakDetection\DiagnosedApplications\ToDesk.exe'
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Tracing\Updater_RASAPI32'
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Tracing\Updater_RASMANCS'
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{EDF64224-A462-44AC-8D34-7277C8DF5897}'
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\ZulerCLSID'
)
$paths = @("$dir\ToDesk.exe", "$($dir -replace '\\[^\\]+$', '\current')\ToDesk.exe")
$registryValues = @()
foreach ($p in $paths) {
    $rot13 = -join ($p.ToCharArray() | ForEach-Object { if ($_ -match '[a-mA-M]') { [char]([int]$_ + 13) } elseif ($_ -match '[n-zN-Z]') { [char]([int]$_ - 13) } else { $_ } })
    $registryValues += "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\UserAssist\{CEBFF5CD-ACE2-4F4F-9178-9926F41749EA}\Count|$rot13"
    $registryValues += "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store|$p"
}
Remove-AppData -LocalPaths $localPaths -RegistryPaths $registryPaths -RegistryValues $registryValues