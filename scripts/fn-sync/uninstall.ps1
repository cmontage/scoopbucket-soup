$localPaths = @(
    "$env:APPDATA\com.fn-sync-client.app"
    "$env:LOCALAPPDATA\com.fn-sync-client.app"
)
$userSID = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
$registryPaths = @(
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\*\shellex\ContextMenuHandlers\FnSyncTraditionalMenu"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\AllFileSystemObjects\shellex\ContextMenuHandlers\FnSyncTraditionalMenu"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\CLSID\{3F8A7B2C-9D4E-5F6A-B1C2-D3E4F5A6B7D0}"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\Directory\Background\shellex\ContextMenuHandlers\FnSyncTraditionalMenu"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\Directory\shellex\ContextMenuHandlers\FnSyncTraditionalMenu"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\Drive\shellex\ContextMenuHandlers\FnSyncTraditionalMenu"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\fnsync"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\Folder\shellex\ContextMenuHandlers\FnSyncTraditionalMenu"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\fn-sync-client"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\飞牛同步"
)
$registryValues = @(
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Run|飞牛同步"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved|{3F8A7B2C-9D4E-5F6A-B1C2-D3E4F5A6B7D0}"
)
# Remove firewall rules for fn-sync-client.exe
Get-NetFirewallRule -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like '*fn-sync-client*' } | Remove-NetFirewallRule -ErrorAction SilentlyContinue
Remove-AppData -LocalPaths $localPaths -RegistryPaths $registryPaths -RegistryValues $registryValues
