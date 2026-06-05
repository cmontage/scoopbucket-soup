$localPaths = @(
    "$env:LOCALAPPDATA\Netease\CloudMusic"
)
$userSID = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
$rot13 = [char[]]"$dir\cloudmusic.exe" | ForEach-Object { $c = [int]$_; if (($c -ge 65 -and $c -le 90)) { [char](($c - 65 + 13) % 26 + 65) } elseif (($c -ge 97 -and $c -le 122)) { [char](($c - 97 + 13) % 26 + 97) } else { $_ } }; $rot13Path = ($rot13 -join '') -replace '\\', '\\\\'
$registryPaths = @(
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\cloudmusic.aac'
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\cloudmusic.ape'
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\cloudmusic.cda'
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\cloudmusic.cue'
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\cloudmusic.flac'
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\cloudmusic.m4a'
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\cloudmusic.mp3'
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\cloudmusic.ncm'
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\cloudmusic.ogg'
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\cloudmusic.wav'
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\cloudmusic.wma'
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\orpheus'
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\cloudmusic.exe'
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\网易云音乐'
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Netease'
)
$registryValues = @(
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\UserAssist\{CEBFF5CD-ACE2-4F4F-9178-9926F41749EA}\Count|$rot13Path"
)
$fwKey = 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\FirewallRules'
$escapedDir = [regex]::Escape($dir)
Get-Item $fwKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Property | Where-Object { $_ -match "$escapedDir\\cloudmusic\.exe" } | ForEach-Object { reg.exe delete ($fwKey -replace 'Registry::','') /v $_ /f 2>$null | Out-Null }
$audioKey = "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Internet Explorer\LowRegistry\Audio\PolicyConfig\PropertyStore"
Get-ChildItem $audioKey -ErrorAction SilentlyContinue | Where-Object { (Get-ItemProperty $_.PSPath -ErrorAction SilentlyContinue).PSObject.Properties.Value -match 'cloudmusic' } | ForEach-Object { reg.exe delete ($_.Name -replace 'HKEY_USERS','HKEY_USERS') /f 2>$null | Out-Null }
Remove-AppData -LocalPaths $localPaths -RegistryPaths $registryPaths -RegistryValues $registryValues