{ isStandalone, isDarwin }:

{
  # Add aliases here.
  ch = "container-home.sh";
  hms = (if isStandalone then
    "home-manager"
  else if isDarwin then
    "nix-darwin"
  else
    throw "home-manager only supported in standalone or nix-darwin"
  ) + " switch && unalias -a && exec $SHELL";
  view = "nvim -R";
}
