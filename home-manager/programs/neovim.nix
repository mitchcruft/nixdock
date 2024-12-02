{ pkgs }:

{
  enable = true;
  defaultEditor = true;
  viAlias = true;
  vimAlias = true;
  vimdiffAlias = true;

  extraConfig = ":set number";

  plugins = with pkgs.vimPlugins; [
  ];

}
