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
    homeManager.configRoot = mkOption {
      type = with types; uniq str;
      description = ''
        Root configuration directory for home-manager
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
