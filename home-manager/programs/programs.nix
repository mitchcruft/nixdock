{ pkgs , hostConfig }:

with hostConfig; {
  bat = import ./bat.nix;
  direnv = import ./direnv.nix;
  eza = import ./eza.nix;
  fzf = import ./fzf.nix;
  git = import ./git.nix { inherit gitUsername; };
  home-manager = { enable = true; };
  neovim = import ./neovim.nix { inherit pkgs; };
  ripgrep = import ./ripgrep.nix;
  starship = import ./starship.nix;
  tmux = import ./tmux.nix { inherit pkgs; };
  zsh = import ./zsh.nix { inherit pkgs hostConfig; };
}
