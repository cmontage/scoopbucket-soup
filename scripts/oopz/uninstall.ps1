$localPaths = @(
    "$env:APPDATA\oopz.cn",
    "$env:APPDATA\oopz"
)
$userSID = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
$registryPaths = @(
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\RADAR\HeapLeakDetection\DiagnosedApplications\ffmpeg.exe'
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\RADAR\HeapLeakDetection\DiagnosedApplications\oopz.exe'
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Internet Explorer\LowRegistry\Audio\PolicyConfig\PropertyStore\1dee682_0"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Internet Explorer\LowRegistry\Audio\PolicyConfig\PropertyStore\54104bf5_0"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Internet Explorer\LowRegistry\Audio\PolicyConfig\PropertyStore\5fa83ac1_0"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\oopz"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Oopz"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\TRTC"
)

$audioKey = "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Internet Explorer\LowRegistry\Audio\PolicyConfig\PropertyStore"
Get-ChildItem $audioKey -ErrorAction SilentlyContinue | Where-Object {
    (Get-ItemProperty $_.PSPath -ErrorAction SilentlyContinue).'(default)' -match 'oopz'
} | ForEach-Object { $registryPaths += $_.PSPath }

$paths = @(
    "$dir\oopz.exe"
    "$dir\oopz-runner.exe"
    "$($dir -replace '\\[^\\]+$', '\current')\oopz.exe"
    "$($dir -replace '\\[^\\]+$', '\current')\oopz-runner.exe"
    'D:\Apps\Software-NP\oopz\oopz.exe'
    'D:\Apps\Software-NP\oopz\oopz-runner.exe'
)
$registryValues = @()
foreach ($p in $paths) {
    $rot13 = -join ($p.ToCharArray() | ForEach-Object { if ($_ -match '[a-mA-M]') { [char]([int]$_ + 13) } elseif ($_ -match '[n-zN-Z]') { [char]([int]$_ - 13) } else { $_ } })
    $registryValues += "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\UserAssist\{CEBFF5CD-ACE2-4F4F-9178-9926F41749EA}\Count|$rot13"
    $registryValues += "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store|$p"
}
$registryValues += "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\UserAssist\{F4E57C4B-2036-45F0-A9AB-443BCFE33D9F}\Count|{0139Q44R-6NSR-49S2-8690-3QNSPNR6SSO8}\Bbcm.yax"

Remove-AppData -LocalPaths $localPaths -RegistryPaths $registryPaths -RegistryValues $registryValues
