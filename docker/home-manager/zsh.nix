{ pkgs, ... }:

{
  enable = true;
  autosuggestion = {
    enable = true;
  };
  history = {
    size = 1000;
    save = 999;
  };
  plugins = [
    {
      name = "powerlevel10k";
      src = pkgs.zsh-powerlevel10k;
      file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    }
  ];
  initExtra = ''
    source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
  '' + (builtins.readFile ./config/p10k.zsh);
}
