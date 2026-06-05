Remove-Junction "$env:LOCALAPPDATA\Quark" -ErrorAction SilentlyContinue | Out-Null
$localPaths = @(
    "$env:LOCALAPPDATA\QuarkUpdater"
    "$env:LOCALAPPDATA\QuarkCloudDrive"
    "$env:WINDIR\system32\Tasks\QuarkUpdaterUser"
    "$env:APPDATA\The Quark Authors"
    "$env:APPDATA\Quark"
)
$userSID = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
$registryPaths = @(
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\MIME\Database\Content Type\application/pdf'
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\MIME\Database\Content Type\application/xhtml+xml'
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\MIME\Database\Content Type\image/webp'
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Logon\{54A7C083-6E8C-4A08-8581-6B5683FC6890}'
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{54A7C083-6E8C-4A08-8581-6B5683FC6890}'
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\QuarkUpdaterUser'
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\.mhtml"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\.pdf"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\.torrent"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\.webp"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\.xht"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\Applications\quark.exe"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\ChromiumPDF"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\CLSID\{43DC55E6-ED2C-434B-BF97-F8EE267D58FE}"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\CLSID\{67EDF60B-AF47-5981-BA29-54366F91C34B}"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\CLSID\{AAFE3A0E-952F-5312-9E85-35F2130387A7}"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\CLSID\{CA0408F4-7585-4A96-96CA-E8F3EE6B5F58}"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\Interface\{62E3D48B-6679-577D-92C9-54991473D7A6}"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\Interface\{E6A00D20-9D63-581C-B8D7-0C92C48A8761}"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\magnet"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\qklink"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\Quark.torrent"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\QuarkUpdaterUpdate.Update3WebUser"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\TypeLib\{62E3D48B-6679-577D-92C9-54991473D7A6}"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\TypeLib\{E6A00D20-9D63-581C-B8D7-0C92C48A8761}"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\Wow6432Node\Interface\{62E3D48B-6679-577D-92C9-54991473D7A6}"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\Wow6432Node\Interface\{E6A00D20-9D63-581C-B8D7-0C92C48A8761}"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\quark.exe"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{FB7670C2-7F99-426D-B687-21BB585A5C73}_is1"
)
Get-ChildItem -Path "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes" -Filter "QuarkHTM*" -ErrorAction SilentlyContinue | ForEach-Object { $registryPaths += $_.PSPath }
$registryValues = @(
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\.htm\OpenWithProgids|QuarkHTM.htm"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\.html\OpenWithProgids|QuarkHTM.html"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\.shtml\OpenWithProgids|QuarkHTM.shtml"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\.svg\OpenWithProgids|QuarkHTM.svg"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Classes\.xhtml\OpenWithProgids|QuarkHTM.xhtml"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.mkv\UserChoice|ProgID"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.mov\UserChoice|ProgID"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.ts\UserChoice|ProgID"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Run|quark"
    "Registry::HKEY_USERS\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Run|QuarkUpdaterTaskUser1.0.0.21"
)
Remove-AppData -LocalPaths $localPaths -RegistryPaths $registryPaths -RegistryValues $registryValues