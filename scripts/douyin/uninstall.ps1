$localPaths = @(
    "$env:APPDATA\douyin"
    "$env:LOCALAPPDATA\app_shell_cache_6383"
)
$userSID = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
$registryPaths = @(
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\ByteDance'
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\douyin'
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\RADAR\HeapLeakDetection\DiagnosedApplications\douyin.exe'
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{93A114D2-6260-4F6B-90D6-E342D323685C}'
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\douyin-pc"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\SystemFileAssociations\.jpeg"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\SystemFileAssociations\.jpg"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\SystemFileAssociations\.mp4"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\SystemFileAssociations\.png"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\ByteDance"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\douyin"
)
$registryValues = @(
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\UserAssist\{CEBFF5CD-ACE2-4F4F-9178-9926F41749EA}\Count|Q:\\Nccf\\Fpbbc\\FpbbcNccf\\nccf\\qbhlva\\pheerag\\qbhlva.rkr"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\UserAssist\{F4E57C4B-2036-45F0-A9AB-443BCFE33D9F}\Count|{N77S5Q77-2R2O-44P3-N6N2-NON601054N51}\\Fpbbc Nccf\\抖音.yax"
)
Remove-AppData -LocalPaths $localPaths -RegistryPaths $registryPaths -RegistryValues $registryValues