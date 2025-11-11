# Script para crear acceso directo de NutriTrack
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$PSScriptRoot\Iniciar NutriTrack.lnk")
$Shortcut.TargetPath = "PowerShell.exe"
$Shortcut.Arguments = "-ExecutionPolicy Bypass -File `"$PSScriptRoot\start-nutritrack.ps1`""
$Shortcut.WorkingDirectory = "$PSScriptRoot"
$Shortcut.IconLocation = "shell32.dll,25"
$Shortcut.Description = "Iniciar servicios de NutriTrack (Backend + Frontend)"
$Shortcut.Save()

Write-Host "Acceso directo creado: Iniciar NutriTrack.lnk" -ForegroundColor Green
Write-Host "Puedes mover este acceso directo al escritorio si deseas" -ForegroundColor Yellow