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
  PATH = "${singleNixProfile}:${multiNixProfile}:${swBin}:${userBin}:${homeManagerBin}:$HOME/.local/bin:$PATH";

  # Use bat for manpages
  MANPAGER = "sh -c 'col -bx | bat -l man -p'";
  MANROFFOPT = "-c";

  # Use dracula for eza and fzf
  EZA_COLORS = "uu=36:gu=37:sn=32:sb=32:da=34:ur=34:uw=35:ux=36:ue=36:gr=34:gw=35:gx=36:tr=34:tw=35:tx=36:";
  FZF_DEFAULT_OPTS = "--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4";

}
