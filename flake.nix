{
  description = "home-manager / nix-darwin configuration";

  inputs = {

    # Release 24.11
    nixpkgs-stable = {
      url = "github:NixOS/nixpkgs/release-24.11";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nix-darwin-stable = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    # unstable
    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/master";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-darwin-unstable = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Unversioned
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:Homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = inputs@{
    self,
    nixpkgs-stable, home-manager-stable, nix-darwin-stable,
    nixpkgs-unstable, home-manager-unstable, nix-darwin-unstable,
    nix-homebrew, homebrew-core, homebrew-cask, ...
  }:
  let
    hostConfig = import ./.hostconfig.nix;
    nixpkgs = if hostConfig.isNixStable then nixpkgs-stable else nixpkgs-unstable;
    home-manager = if hostConfig.isNixStable then home-manager-stable else home-manager-unstable;
    nix-darwin = if hostConfig.isNixStable then nix-darwin-stable else nix-darwin-unstable;
    pkgs = nixpkgs.legacyPackages.${hostConfig.system};
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

