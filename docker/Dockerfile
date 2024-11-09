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
RUN pacman -S --needed --noconfirm nix
RUN pacman -S --needed --noconfirm stow
RUN pacman -S --needed --noconfirm tmux
RUN pacman -S --needed --noconfirm zsh

RUN echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/01_wheel
RUN ["useradd", "-m", "-G", "nix-users,wheel", "-s", "/bin/zsh", "m"]

# Set up nix
RUN nix-channel --add https://nixos.org/channels/nixpkgs-unstable
# RUN nix-channel --update

USER "m"

# Install yay
#WORKDIR /tmp
#RUN ["git", "clone", "https://aur.archlinux.org/yay.git"]
#WORKDIR /tmp/yay
#RUN ["makepkg", "-si", "--noconfirm"]

# Create home directory
WORKDIR /home/m
RUN mkdir bin
RUN mkdir src


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
