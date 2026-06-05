$localPaths = @(
    "$env:APPDATA\com.example"
)
$userSID = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
$registryPaths = @(
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{B5AB0F57-7B30-4B5B-907B-85709A3EFD32}'
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Internet Explorer\LowRegistry\Audio\PolicyConfig\PropertyStore\f46d8ac4_0"
)
$paths = @("$dir\piliplus.exe", "$($dir -replace '\\[^\\]+$', '\current')\piliplus.exe")
$registryValues = @()
foreach ($p in $paths) {
    $rot13 = -join ($p.ToCharArray() | ForEach-Object { if ($_ -match '[a-mA-M]') { [char]([int]$_ + 13) } elseif ($_ -match '[n-zN-Z]') { [char]([int]$_ - 13) } else { $_ } })
    $registryValues += "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\UserAssist\{CEBFF5CD-ACE2-4F4F-9178-9926F41749EA}\Count|$rot13"
    $registryValues += "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store|$p"
}
Remove-AppData -RegistryPaths $registryPaths -RegistryValues $registryValues