{ pkgs }:

with pkgs; [
    (nerdfonts.override { fonts = [
      "JetBrainsMono"
      # Fonts are super large.  Enable as needed.
      #"FiraCode"
      #"GeistMono"
      #"Noto"
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
