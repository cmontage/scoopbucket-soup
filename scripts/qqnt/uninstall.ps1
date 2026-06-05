$localPaths = @(
    "$env:APPDATA\QQ"
    "$env:APPDATA\QQEX"
    "$env:APPDATA\Tencent\QQ"
    "$env:APPDATA\Tencent\QQNT"
    "$env:APPDATA\Tencent\QQLive"
    "$env:APPDATA\Tencent\qimei"
    "$env:APPDATA\Tencent\Logs"
    "$env:APPDATA\Tencent\libsdk"
    "$([Environment]::GetFolderPath('CommonDocuments'))\Tencent"
)
$userSID = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
$registryPaths = @(
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\QQ'
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Tencent'
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\guild-notification"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\mqqapi"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\ntqq-notification"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\tencent"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Tencent"
)
$registryValues = @(
    'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\FirewallRules|{44D70CA3-41D2-4298-A5C1-74186957419D}'
    'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\FirewallRules|{EA101638-843F-46F0-A7D1-3BAD6A2B0799}'
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store|$dir\Files\QQ.exe"
)
Remove-AppData -LocalPaths $localPaths -RegistryPaths $registryPaths -RegistryValues $registryValues