$localPaths = @(
    "$env:LOCALAPPDATA\123pan-updater"
    "$env:APPDATA\123pan"
    "$env:ProgramData\123SyncCloud"
)
$sid = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
$regPaths = @(
    "HKLM\SOFTWARE\Classes\*\shell\123pan"
    "HKLM\SOFTWARE\Classes\Directory\shell\123pan"
    "HKLM\SOFTWARE\Wow6432Node\123pan"
    "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\123pan"
    "HKLM\SYSTEM\CurrentControlSet\Services\123SyncCloud Maintenance Service"
    "HKLM\SYSTEM\CurrentControlSet\Services\123SyncCloud Upgrade Service"
    "HKU\$sid\SOFTWARE\123pan"
    "HKU\$sid\SOFTWARE\Classes\CLSID\{D5BE1ADA-C1D3-4DF9-9317-95D61C28F6FA}\DefaultIcon"
    "HKU\$sid\SOFTWARE\Classes\CLSID\{D5BE1ADA-C1D3-4DF9-9317-95D61C28F6FA}\Shell"
    "HKU\$sid\SOFTWARE\Classes\pan123\shell\open"
)
$regValues = @(
    "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment|123pan"
    "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules|TCP Query User{5A335076-A09D-42BF-8A77-C7C3756B0DC5}$dir\\123pan.exe"
    "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules|UDP Query User{6C459033-4495-4755-8F71-F95B628D7FAF}$dir\\123pan.exe"
    "HKU\$sid\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\UserAssist\{CEBFF5CD-ACE2-4F4F-9178-9926F41749EA}\Count|P:\\Hfref\\JvaGrfg\\NccQngn\\Ybpny\\123cna\\123cna.rkr"
    "HKU\$sid\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store|$dir\\123pan.exe"
)
Remove-AppData -LocalPaths $localPaths -RegistryPaths $regPaths -RegistryValues $regValues