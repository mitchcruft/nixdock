{
  description = "home-manager / nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

  };

  outputs = inputs@{
    self, nixpkgs, home-manager, nix-darwin, nix-homebrew, homebrew-core,
    homebrew-cask, ...
  }:
  let
    pkgs = nixpkgs.legacyPackages.${hostConfig.system};
    hostConfig = import ./.hostconfig.nix;
  in with hostConfig;
  {

    homeConfigurations = if isStandalone then {
      ${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ({ ... }: import ./home-manager/home.nix {
            inherit pkgs hostConfig;
 	 })
        ];
      };
    } else null;

    darwinConfigurations = if isDarwin then import ./darwin/darwin.nix {
      inherit pkgs hostConfig home-manager nix-darwin nix-homebrew homebrew-core homebrew-cask;
      configurationRevision = self.rev or self.dirtyRev or null;
    } else null;

  };
}

