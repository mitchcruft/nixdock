{ pkgs
, stateVersion
, username
, homeDirectory
}:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = { pkgs, ... }: {
      home = {
        inherit (pkgs);
        packages = import ./packages.nix { inherit pkgs; };
        sessionVariables = import ./env.nix { inherit pkgs username; };
        shellAliases = import ./aliases.nix;
        inherit stateVersion username homeDirectory;
      };
      programs = import ./programs.nix { inherit pkgs; };
      nix = {
        package = pkgs.nix;
        extraOptions = "experimental-features = nix-command";
      };
    };
  };
}
