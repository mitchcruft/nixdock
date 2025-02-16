{ pkgs , hostConfig }:

with hostConfig; {
  home = {
    inherit (pkgs);
    packages = import ./packages.nix {
      inherit pkgs hostConfig;
    };
    sessionVariables = import ./env.nix {
      inherit pkgs username isStandalone isDarwin;
    };
    shellAliases = import ./aliases.nix {
      inherit isStandalone isDarwin;
    };
    inherit username homeDirectory stateVersion;
  };

  programs = import ./programs/programs.nix {
    inherit pkgs hostConfig;
  };

  # TODO: Move to using programs/ghostty once nixpkg works with Darwin
  xdg = if hostConfig.isDarwin then if !hostConfig.isHeadless then
    { configFile = { "ghostty/config".text = builtins.readFile ./programs/config/ghostty; } ; }
  else {} else {};

  nix = {
    package = pkgs.lib.mkForce pkgs.nix;
    extraOptions = "experimental-features = nix-command flakes";
  };
}
