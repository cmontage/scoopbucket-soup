$userSID = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
$localPaths = @(
    "$env:APPDATA\utForpc"
    "$env:APPDATA\aDrive"
)
$registryPaths = @(
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\smartdrive"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Internet Explorer\LowRegistry\Audio\PolicyConfig\PropertyStore\fd539040_0"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\300f80e0-781e-56db-ae9d-9d0190486ca9"
)
$registryValues = @(
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Run|com.alicloud.smartdrive"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\UserAssist\{F4E57C4B-2036-45F0-A9AB-443BCFE33D9F}\Count|{N77S5Q77-2R2O-44P3-N6N2-NON601054N51}\阿里云盘\阿里云盘.yax"
)

# 防火墙规则
Get-Item -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Property | Where-Object { $_ -match '(?i)aDrive\.exe' } | ForEach-Object {
    $registryValues += "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\FirewallRules|$_"
}

# UserAssist ROT13
$rot13Path = -join ("$dir\aDrive.exe".ToCharArray() | ForEach-Object {
    if ($_ -match '[a-mA-M]') { [char]([int]$_ + 13) }
    elseif ($_ -match '[n-zN-Z]') { [char]([int]$_ - 13) }
    else { $_ }
})
$registryValues += "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\UserAssist\{CEBFF5CD-ACE2-4F4F-9178-9926F41749EA}\Count|$rot13Path"

# AppCompatFlags Compatibility Assistant
$paths = @("$dir\aDrive.exe", "$($dir -replace '\\\\[^\\]+$', '\current')\aDrive.exe")
foreach ($p in $paths) {
    $registryValues += "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store|$p"
}

Remove-AppData -LocalPaths $localPaths -RegistryPaths $registryPaths -RegistryValues $registryValues