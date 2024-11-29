:: Remove old Ubuntu installation
wsl --terminate Ubuntu
wsl --unregister Ubuntu

:: Install Ubuntu
:: TODO: Figure out how to avoid user input here
wsl --install Ubuntu

:: Set Ubuntu as default
wsl -s Ubuntu
wsl -t Ubuntu

:: Download and run post-installation script
wsl -u root -d Ubuntu curl -Lo "/tmp/setup-standalone-root.sh" "https://raw.githubusercontent.com/mitchcruft/nixdock/refs/heads/main/bin/setup-standalone-root.sh"
wsl -u root -d Ubuntu bash /tmp/setup-standalone-root.sh --wsl --hostname wsl-ubuntu --user m --ubuntu

:: Reset wsl to force settings update
wsl -t Ubuntu
wsl -d Ubuntu
