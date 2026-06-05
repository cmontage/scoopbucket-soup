$localPaths = @(
    "$env:APPDATA\PLogs"
    "$env:APPDATA\BaiduYunKernel"
    "$env:APPDATA\BaiduYunGuanjia"
    "$env:APPDATA\BaiduNetdisk"
    "$env:APPDATA\Baidu\BaiduNetdisk"
    "$env:APPDATA\Baidu\BaiduYunKernel"
)
$sid = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
$regPaths = @(
    "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{2015CFAB-8C4A-4331-A38A-46DD54245FA7}"
    "HKU\$sid\SOFTWARE\Classes\CLSID\{679F137C-3162-45da-BE3C-2F9C3D093F64}\DefaultIcon"
    "HKU\$sid\SOFTWARE\Classes\CLSID\{679F137C-3162-45da-BE3C-2F9C3D093F64}\Shell"
)
$regValues = @(
    "HKU\$sid\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\UserAssist\{CEBFF5CD-ACE2-4F4F-9178-9926F41749EA}\Count|Q:\\Nccf\\Fpbbc\\FpbbcNccf\\nccf\\onvqhargqvfx\\pheerag\\OnvqhArgqvfx.rkr"
    "HKU\$sid\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\UserAssist\{F4E57C4B-2036-45F0-A9AB-443BCFE33D9F}\Count|{N77S5Q77-2R2O-44P3-N6N2-NON601054N51}\\Fpbbc Nccf\\百度网盘.yax"
    "HKU\$sid\SOFTWARE\Microsoft\Windows\CurrentVersion\Run|BaiduYunGuanjia"
)
Remove-AppData -LocalPaths $localPaths -RegistryPaths $regPaths -RegistryValues $regValues