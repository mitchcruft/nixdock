{ pkgs, username }:

let
  nixProfile = "/etc/profiles/per-user/${username}/bin";
  swBin = "/run/current-system/sw/bin";
  userBin = "$HOME/bin";
in
{
  PATH = "${nixProfile}:${swBin}:${userBin}:$PATH";
}
