{ pkgs, username, stateVersion, homeDirectory }:

(
  import ../home-manager {
    inherit pkgs username stateVersion homeDirectory;
  }
).home-manager.users.m { inherit pkgs; }
