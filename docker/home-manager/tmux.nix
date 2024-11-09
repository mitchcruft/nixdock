{ pkgs, ... } :
{
  enable = true;
  extraConfig = (builtins.readFile ./config/tmux.conf);
  plugins = [
    {
      plugin = pkgs.tmuxPlugins.dracula;
      extraConfig = (builtins.readFile ./config/tmux.dracula.conf);
    }
    pkgs.tmuxPlugins.vim-tmux-navigator
  ];
}
