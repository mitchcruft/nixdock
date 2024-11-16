{ pkgs, username }:

let
  # TODO: Determine which to use based on the installation?
  singleNixProfile = "$HOME/.nix-profile/bin";
  multiNixProfile = "/etc/profiles/per-user/${username}/bin";
  swBin = "/run/current-system/sw/bin";
  userBin = "$HOME/bin";
in
{
  PATH = "${singleNixProfile}:${multiNixProfile}:${swBin}:${userBin}:$PATH";
}
