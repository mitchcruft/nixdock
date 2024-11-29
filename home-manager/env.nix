{ pkgs, username, isStandalone, isDarwin}:

let
  singleNixProfile = "$HOME/.nix-profile/bin";
  multiNixProfile = "/etc/profiles/per-user/${username}/bin";
  homeManagerBin = if isStandalone then
    "$HOME/.config/home-manager/bin"
  else if isDarwin then
    "$HOME/.config/nix-darwin/bin"
  else
    throw "home-manager only supported in standalone or nix-darwin";
  swBin = "/run/current-system/sw/bin";
  userBin = "$HOME/bin";
in
{
  PATH = "${singleNixProfile}:${multiNixProfile}:${swBin}:${userBin}:${homeManagerBin}:$PATH";
}
