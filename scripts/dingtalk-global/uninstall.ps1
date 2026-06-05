$localPaths = @(
    "$env:APPDATA\DingTalk"
    "$env:APPDATA\dinglive"
    "$env:LOCALAPPDATA\DingTalk_108"
    "$env:LOCALAPPDATA\DingTalk_91"
    "$env:LOCALAPPDATA\DingTalk_133"
)
$sid = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
$hkuPath = "HKU\$sid"
$regPaths = @(
    "Registry::$hkuPath\SOFTWARE\Classes\dingtalk"
    "Registry::$hkuPath\SOFTWARE\Classes\dingtalkscheme"
    "Registry::$hkuPath\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\DingTalk.exe"
    "Registry::$hkuPath\SOFTWARE\DingTalk"
)
if ($global -and $cmd -eq 'uninstall') {
    $regPaths += "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{37C2D57E-8AD1-458B-B221-552C666E5FDC}"
}
$regValues = @(
    "HKU\$sid\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\UserAssist\{CEBFF5CD-ACE2-4F4F-9178-9926F41749EA}\Count|Q:\\Nccf\\Fpbbc\\FpbbcNccf\\nccf\\qvatgnyx\\pheerag\\QvatgnyxYnhapure.rkr"
    "HKU\$sid\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\UserAssist\{F4E57C4B-2036-45F0-A9AB-443BCFE33D9F}\Count|{N77S5Q77-2R2O-44P3-N6N2-NON601054N51}\\Fpbbc Nccf\\钉钉.yax"
)
Remove-AppData -LocalPaths $localPaths -RegistryPaths $regPaths -RegistryValues $regValues