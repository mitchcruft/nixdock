{ isStandalone, isDarwin }:

{
  # Add aliases here.
  ch = "container-home.sh";
  hms = (if isStandalone then
    "home-manager --flake path:$HOME/.config/home-manager"
  else if isDarwin then
    "darwin-rebuild --flake path:$HOME/.config/nix-darwin"
  else
    throw "home-manager only supported in standalone or nix-darwin"
  ) + " switch && unalias -a && exec $SHELL";
  view = "nvim -R";
}
