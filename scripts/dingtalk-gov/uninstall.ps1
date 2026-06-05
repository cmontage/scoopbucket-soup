$localPaths = @(
    "$env:APPDATA\DingTalkGov"
    "$env:APPDATA\utForpc"
    "$env:LOCALAPPDATA\DingTalkGov_91"
    "$env:LOCALAPPDATA\DingTalkGov_108"
)
$userSID = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
$registryPaths = @(
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\浙政钉'
    "Registry::HKEY_USERS\$userSID\SOFTWARE\DingTalk"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\DingTalkGov"
)
Remove-AppData -LocalPaths $localPaths -RegistryPaths $registryPaths