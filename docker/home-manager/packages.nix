{ pkgs }:

with pkgs; [
    (nerdfonts.override { fonts = [
      "FiraCode"
      "GeistMono"
      "JetBrainsMono"
      "Noto"
    ]; })

    bind
    delta
    gh
    git
    go
    man-pages
    tmux
    zsh
]
