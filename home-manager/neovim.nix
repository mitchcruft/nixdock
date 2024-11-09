{ pkgs }:
{
  enable = true;
  viAlias = true;
  vimAlias = true;

  #extraConfig = "";

  plugins = with pkgs.vimPlugins; [
  #  bufferline-nvim
  #  lualine-nvim
  #  dashboard-nvim
  #  # TODO: Consider subset
  #  nvim-treesitter.withAllGrammars
  #  dracula-nvim
  ];
}
