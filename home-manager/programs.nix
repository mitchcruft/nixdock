{ pkgs , hostConfig }:

with hostConfig; {
  git = import ./git.nix { inherit gitUsername; };
  home-manager = { enable = true; };
  neovim = import ./neovim.nix { inherit pkgs; };
  tmux = import ./tmux.nix { inherit pkgs; };
  zsh = import ./zsh.nix { inherit pkgs; };
  wezterm = if isHeadless then {} else import ./wezterm.nix;
}
