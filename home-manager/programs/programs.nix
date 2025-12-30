{ pkgs , hostConfig }:

with hostConfig; {
  bat = import ./bat.nix;
  delta = import ./delta.nix;
  eza = import ./eza.nix;
  fzf = import ./fzf.nix;
  git = import ./git.nix { inherit gitUsername; };
  home-manager = { enable = true; };
  mise = import ./mise.nix { inherit hostConfig; };
  neovim = import ./neovim.nix { inherit pkgs; };
  ripgrep = import ./ripgrep.nix;
  starship = import ./starship.nix { inherit hostConfig; };
  tmux = import ./tmux.nix { inherit pkgs; };
  zsh = import ./zsh.nix { inherit pkgs; };
}
