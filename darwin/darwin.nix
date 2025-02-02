{ pkgs, hostConfig, home-manager, nix-darwin, nix-homebrew, homebrew-core, homebrew-cask, configurationRevision }:

with hostConfig; {
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
        system.configurationRevision = configurationRevision;

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
            "alt-tab"
            "orbstack"
	    "ghostty"
          ];
        };
        users.users.${username} = {
          name = username;
          home = homeDirectory;
          isHidden = false;
          shell = pkgs.zsh;
        };
        home-manager.users.${username} = import ../home-manager/home.nix {
          inherit pkgs hostConfig;
        };
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
}
