{ isStandalone, isDarwin }:

let

  hmDir = if isStandalone then
      "$HOME/.config/home-manager"
    else if isDarwin then
      "$HOME/.config/nix-darwin"
    else
      throw "home-manager only supported in standalone or nix-darwin"
    ;

  hmMake = "make -C " + hmDir;
in
{
  cat = "bat";
  ch = "container-home.sh";
  view = "nvim -R";

  # cd to home-manager/nix-darwin
  hmc = "cd " + hmDir;
  # git pull
  hmp = "(cd " + hmDir + "&& git pull)";
  # Switch home-manager/nix-darwin
  hms = hmMake + " && unalias -a && unset -m '*_SOURCED' && exec $SHELL";
  # Dry run witch home-manager/nix-darwin
  hmd = hmMake + " dry";
  # Build and diff home-manager/nix-darwin host config
  hmhc = hmMake + " hc";
}
