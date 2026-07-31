$localPaths = @(
    "$env:LOCALAPPDATA\\com.pot-app.desktop\",
    "$env:APPDATA\\com.pot-app.desktop\"
)
Remove-AppData -LocalPaths $localPaths