{ isStandalone, isDarwin }:

let
  hmMake = "make -C " + (
    if isStandalone then
      "$HOME/.config/home-manager"
    else if isDarwin then
      "$HOME/.config/nix-darwin"
    else
      throw "home-manager only supported in standalone or nix-darwin"
  );
in
{
  cat = "bat";
  ch = "container-home.sh";
  view = "nvim -R";

  # Switch home-manager/nix-darwin
  hms = hmMake + " && unalias -a && exec $SHELL";
  # Dry run witch home-manager/nix-darwin
  hmd = hmMake + " dry";
  # Build and diff home-manager/nix-darwin host config
  hmhc = hmMake + " hc";
}
