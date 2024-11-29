{ pkgs, username, configRoot }:

let
  singleNixProfile = "$HOME/.nix-profile/bin";
  multiNixProfile = "/etc/profiles/per-user/${username}/bin";
  homeManagerBin = configRoot + "/bin";
  swBin = "/run/current-system/sw/bin";
  userBin = "$HOME/bin";
in
{
  PATH = "${singleNixProfile}:${multiNixProfile}:${swBin}:${userBin}:${homeManagerBin}:$PATH";
}
