#!/bin/bash

set -ex

function fail {
  echo "$@" >&2
  exit 1
}

function usage {
  echo "usage: $0" >&2
  exit 1
}

[ "${USER}" ] || USER="$(whoami)"
[ "${USER}" ] || fail 'Cannot identify \${USER}'

[ "${HOME}" ] || HOME="/home/${USER}"
[ "${HOME}" ] || fail 'Cannot identify \${HOME}'

[ "${HOSTNAME}" ] || HOSTNAME="$(hostname)"
[ "${HOSTNAME}" ] || fail 'Cannot identify \${HOSTNAME}'

OS=

if [ -f /etc/os-release ]; then
  . /etc/os-release
  case "$ID" in
    ubuntu)
      OS="ubuntu"
      ;;
    arch|archarm)
      OS="arch"
      ;;
    nixos)
      OS="nixos"
      ;;
  esac
fi

if [ -z "$OS" ]; then
  if type uname >/dev/null 2>&1; then
    case "$(uname)" in
      Darwin)
        OS="darwin"
        ;;
    esac
  fi
fi

function generate_standalone {
echo '
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
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    stateVersion = "24.05";
    username = "'${USER}'";
    homeDirectory = "'${HOME}'";
  in
  {
    homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./home.nix
      ];
    };
  };

}
'
}

function generate_nix_darwin {
echo '
{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
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
    self, nix-darwin, nixpkgs, home-manager, nix-homebrew, homebrew-core,
    homebrew-cask, ...
  }:
  let
    system = "aarch64-darwin";
    pkgs = nixpkgs.legacyPackages.${system};
    stateVersion = "24.05";
    username = "'${USER}'";
    homeDirectory = "'${HOME}'";
    hostname = "'${HOSTNAME}'";
    darwinConfiguration = { pkgs, ... }: {
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
      nixpkgs.hostPlatform = "${system}";
    };
  in
  {
    darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {

      modules = [
        darwinConfiguration
        home-manager.darwinModules.home-manager
        {
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
	  home-manager = (import ./home-manager/default.nix {
	    pkgs = self.darwinPackages;
	    inherit stateVersion username homeDirectory;
	  }).home-manager;
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
            mutableTaps = false;
          };
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations.${hostname}.pkgs;
  };
}
'
}

case "$OS" in
  ubuntu|arch)
    generate_standalone
    ;;
  darwin)
    generate_nix_darwin
    ;;
  nixos)
    fail "NixOS unsupported!"
    ;;
  *)
    fail "OS unsupported!"
    ;;
esac
