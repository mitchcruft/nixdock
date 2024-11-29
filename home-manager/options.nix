{ config, pkgs, lib, ...}:

let
  cfg = config.homeManager;
in

with lib;

{
  options = {
    homeManager.enable = mkOption {
      default = false;
      type = with types; bool;
      description = ''
        Whether to enable home-manager (standalone)
      '';
    };
    homeManager.isStandalone = mkOption {
      default = false;
      type = with types; bool;
      description = ''
        Whether home-manager is running in standalone
      '';
    };
    homeManager.isDarwin  = mkOption {
      default = false;
      type = with types; bool;
      description = ''
        Whether home-manager is running under nix-darwin
      '';
    };
    homeManager.username = mkOption {
      type = with types; uniq str;
      description = ''
        username for home-manager
      '';
    };
    homeManager.homeDirectory = mkOption {
      type = with types; uniq str;
      description = ''
        home directory for home-manager
      '';
    };
    homeManager.stateVersion = mkOption {
      type = with types; uniq str;
      description = ''
        stateVersion for home-manager
      '';
    };
  };
}
