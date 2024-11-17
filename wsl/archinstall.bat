cd $env:TEMP

:: Remove old Arch installation
wsl --terminate Arch
wsl --unregister Arch

:: Install WSL from https://github.com/yuk7/ArchWSL
if (-Not (Test-Path ".\Arch\Arch.exe")) {
  Invoke-WebRequest -Uri "https://github.com/yuk7/ArchWSL/releases/download/24.4.28.0/Arch.zip" -OutFile "Arch.zip"
  Expand-Archive -Path "Arch.zip" -DestinationPath "Arch"
}
.\Arch\Arch.exe

:: Set Arch as default
wsl -s Arch

:: Download Arch post-installation script
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/mitchcruft/nixdock/refs/heads/main/wsl/install.sh" -OutFile "\\wsl$\Arch\tmp\install.sh"

:: Login and execute
wsl -d Arch sh /tmp/install.sh
