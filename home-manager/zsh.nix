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
    }
  ];
  initExtraFirst = ''
    source ${pkgs.concatText "p10k-prelude.zsh" [ ./config/p10k-prelude.zsh ]}
  '';
  initExtra = ''
    source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    source ${pkgs.concatText "p10k.zsh" [ ./config/p10k.zsh ]}
  '';
}
