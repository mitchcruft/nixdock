:: Remove old Ubuntu installation
wsl --terminate Ubuntu
wsl --unregister Ubuntu

:: Install Ubuntu
echo | wsl --install Ubuntu

:: Set Ubuntu as default
wsl -s Ubuntu

:: Download and run post-installation script
wsl -d Ubuntu curl -Lo "/tmp/mach-setup.sh" "https://raw.githubusercontent.com/mitchcruft/nixdock/refs/heads/main/bin/mach-setup.sh"
wsl -d Ubuntu sh /tmp/mach-setup.sh

# Reset wsl to force settings update
wsl -t Ubuntu
wsl -d Ubuntu
