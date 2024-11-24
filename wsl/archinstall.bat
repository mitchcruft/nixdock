cd %TEMP%
if NOT EXIST "ArchInstall" (
  mkdir ArchInstall
)
cd ArchInstall

:: Remove old Arch installation
wsl --terminate Arch
wsl --unregister Arch

:: Install WSL from https://github.com/yuk7/ArchWSL
if NOT EXIST ".\Arch.exe" set download=T
if "%1"=="-d" set download=T
if "%download%"=="T" (
  if EXIST "Arch" (
    rmdir /s /q "Arch"
  )
  mkdir "Arch"
  cd "Arch"
  curl -Lo "Arch.zip" "https://github.com/yuk7/ArchWSL/releases/download/24.4.28.0/Arch.zip"
  tar -xf "Arch.zip"
  cd ..
)
echo | .\Arch\Arch.exe

:: Set Arch as default
wsl -s Arch

:: Download and run post-installation script
wsl -d Arch curl -Lo "/tmp/install.sh" "https://raw.githubusercontent.com/mitchcruft/nixdock/refs/heads/main/wsl/install.sh"
wsl -d Arch sh /tmp/install.sh

# Reset wsl to force settings update
wsl -t Arch
wsl -d Arch
