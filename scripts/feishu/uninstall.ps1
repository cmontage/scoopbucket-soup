$localPaths = @(
    "$env:APPDATA\LarkShell"
    "$env:APPDATA\mssdk"
)
$userSID = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
$registryPaths = @(
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\feishu"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\feishu-open"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\lark"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\x-feishu"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Feishu"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Feishu"
)
$registryValues = @(
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Run|Feishu"
)
Remove-AppData -LocalPaths $localPaths -RegistryPaths $registryPaths -RegistryValues $registryValues