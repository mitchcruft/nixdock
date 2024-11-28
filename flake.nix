{
  description = "Home manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
  let
    hostConfigFile = ./.hostconfig.nix;
    hostConfig = import hostConfigFile;
    pkgs = nixpkgs.legacyPackages.${hostConfig.system};
  in with hostConfig;
  {

    homeConfigurations = if hostConfig.isStandalone then {
      ${hostConfig.username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home-manager/default.nix
  	({ config, ... }: {
  	  config.homeManager.enable = true;
  	  config.homeManager.username = hostConfig.username;
  	  config.homeManager.homeDirectory = hostConfig.homeDirectory;
  	  config.homeManager.stateVersion = hostConfig.stateVersion;
          })
        ];
      };
    } else {};

  };
}
