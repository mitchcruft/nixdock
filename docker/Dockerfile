FROM archlinux/archlinux:base-devel

RUN sed -in 's/.*en_US\(.*\)/en_US\1/' /etc/locale.gen
RUN ["locale-gen"]
# TODO Can we avoid having to copy this in?
COPY ["locale.conf", "/etc/locale.conf"]

RUN pacman -Suy --noconfirm
RUN pacman -S --needed --noconfirm bind
RUN pacman -S --needed --noconfirm git
RUN pacman -S --needed --noconfirm git-delta
RUN pacman -S --needed --noconfirm github-cli
# For installing yay
RUN pacman -S --needed --noconfirm go
RUN pacman -S --needed --noconfirm man-db
RUN pacman -S --needed --noconfirm man-pages
RUN pacman -S --needed --noconfirm neovim
RUN pacman -S --needed --noconfirm stow
RUN pacman -S --needed --noconfirm tmux
RUN pacman -S --needed --noconfirm zsh

# Set up user
RUN echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/01_wheel
#RUN ["useradd", "-m", "-G", "nix-users,wheel", "-s", "/bin/zsh", "m"]
#RUN ["useradd", "-m", "-G", "nixbld,wheel", "-s", "/bin/zsh", "m"]
RUN ["useradd", "-m", "-G", "wheel", "-s", "/bin/zsh", "m"]
USER "m"

# Install yay
WORKDIR /tmp
RUN ["git", "clone", "https://aur.archlinux.org/yay.git"]
WORKDIR /tmp/yay
RUN ["makepkg", "-si", "--noconfirm"]

# Set up nix in single-user installation
WORKDIR /tmp
RUN curl --proto '=https' --tlsv1.2 -sSfL https://nixos.org/nix/install -o nix-install.sh
RUN sh nix-install.sh --no-daemon --yes
USER "root"
RUN echo 'PATH=/home/m/.nix-profile/bin:${PATH}' > /etc/profile.d/nix.sh
RUN mkdir /etc/nix
RUN echo 'experimental-features = nix-command flakes' > /etc/nix/nix.conf
USER "m"
ENV PATH="${PATH}:/home/m/.nix-profile/bin"
ENV USER=m
RUN nix-channel --add https://github.com/NixOs/nixpkgs/archive/24.05.tar.gz nixpkgs
RUN nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz home-manager
RUN nix-channel --update

# Create home directory
WORKDIR /home/m
RUN mkdir bin
RUN mkdir src

# TODO: Make this a git clone?
COPY home-manager .config/home-manager
RUN nix run home-manager/release-24.05 -- switch
#RUN nixl home-manager
#RUN home-manager switch


# Initialize home-manager
# TODO: ...

# Clone dotfiles and bootstrap
#WORKDIR /home/m
#COPY . /home/m/.dotfiles
#RUN sudo chown -R m:m /home/m/.dotfiles
#RUN stow -d .dotfiles -t . base
#RUN ln -s .dotfiles/.templates/.zshrc .
#RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git .powerlevel10k 
#RUN git clone https://github.com/tmux-plugins/tpm .tmux/plugins/tpm
#RUN .tmux/plugins/tpm/bin/install_plugins
#RUN ["nvim", "+Lazy! sync", "+qa"]

# TODO: create the shared volume

ENV TERM=xterm-256color
ENV SHELL=/bin/zsh
SHELL ["/bin/zsh", "--login"]
CMD ["/bin/tmux"]
