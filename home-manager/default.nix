{ config, pkgs, lib, ...}:

let
  cfg = config.homeManager;
in

with lib;

{
  imports = [ ./options.nix ];

  home = {
    inherit (pkgs);
    packages = import ./packages.nix { inherit pkgs; };
    sessionVariables = import ./env.nix {
      pkgs = pkgs;
      configRoot = cfg.configRoot;
      username = cfg.username;
    };
    shellAliases = import ./aliases.nix;
    username = cfg.username;
    homeDirectory = cfg.homeDirectory;
    stateVersion = cfg.stateVersion;
  };
  programs = import ./programs.nix { inherit pkgs; };
  nix = {
    package = pkgs.lib.mkForce pkgs.nix;
    extraOptions = "experimental-features = nix-command flakes";
  };
}
