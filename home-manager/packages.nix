{ pkgs, hostConfig }:

let
  baseList = with pkgs; [
    delta
    gh
    tmux
  ];
in
  # Additional packages for non-headless setups.
  baseList ++ (if hostConfig.isHeadless then [] else [
    (pkgs.nerdfonts.override { fonts = [
      "JetBrainsMono"
      # Fonts are super large.  Enable as needed.
      #"FiraCode"
      #"GeistMono"
      #"Noto"
    ];})
  ])
