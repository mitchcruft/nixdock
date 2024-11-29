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
    hostConfigFile = ./.hostconfig.nix;
    hostConfig = import hostConfigFile;
    pkgs = nixpkgs.legacyPackages.${hostConfig.system};
    homeManagerConfig = {
      ${hostConfig.username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home-manager/default.nix
          ({ config, ... }: {
            config.homeManager = with hostConfig; {
            enable = true;
            inherit
              isStandalone
              isDarwin
              username
              homeDirectory
              stateVersion;
            };
          })
        ];
      };
    };
  in with hostConfig;
  {

    #homeConfigurations = if isStandalone then homeManagerConfig else null;
    homeConfigurations = homeManagerConfig;

    darwinConfigurations = if isDarwin then {
      ${hostname} = nix-darwin.lib.darwinSystem {

        modules = [
          {
            # List packages installed in system profile. To search by name, run:
            # $ nix-env -qaP | grep wget
            environment.systemPackages = [];

            # Auto upgrade nix package and the daemon service.
            services.nix-daemon.enable = true;
            nix.package = pkgs.nix;

            # Necessary for using flakes on this system.
            nix.settings.experimental-features = "nix-command flakes";

            # Set Git commit hash for darwin-version.
            system.configurationRevision = self.rev or self.dirtyRev or null;

            # Used for backwards compatibility, please read the changelog before
            # changing.
            # $ darwin-rebuild changelog
            system.stateVersion = 5;

            # The platform the configuration will be used on.
            nixpkgs.hostPlatform = system;
          }
          home-manager.darwinModules.home-manager {
            homebrew = {
              enable = true;
              casks = [
               # "alt-tab"
               # "orbstack"
              ];
            };
            users.users.${username} = {
              name = username;
              home = homeDirectory;
              isHidden = false;
              shell = self.darwinPackages.zsh;
            };
            #home-manager.users.${username} = homeManagerConfig;
          }
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;

              # Apple Silicon Only: Also install Homebrew under the default
              # Intel prefix for Rosetta 2
              # TODO: should be based on x86_64 vs aarch64
              enableRosetta = false;

              # User owning the Homebrew prefix
              user = username;

              # Optional: Declarative tap management
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
              };

              # Optional: Enable fully-declarative tap management
              #
              # With mutableTaps disabled, taps can no longer be added
              # imperatively with `brew tap`.
              mutableTaps = true;
            };
          }
        ];
      };
    } else null;

    # Expose the package set, including overlays, for convenience.
    darwinPackages = if isDarwin then self.darwinConfigurations.${hostname}.pkgs else null;

  };
}

