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

# Increment NIX_SHELL_DEPTH each time you enter nix-shell
if [ -n "$IN_NIX_SHELL" ]; then
    export NIX_SHELL_DEPTH=$(( ''${NIX_SHELL_DEPTH:-0} + 1 ))
fi

# Add depth to the prompt
if [ -n "$NIX_SHELL_DEPTH" ]; then
    PS1="[nix-shell depth $NIX_SHELL_DEPTH] $PS1"
fi
  '';
  initExtra = ''
source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
source ${pkgs.concatText "p10k.zsh" [ ./config/p10k.zsh ]}

( [ "$TERM" = "xterm-ghostty" ] || [ "$TERM_PROGRAM" = "ghostty" ] ) && ! $(which ghostty >/dev/null 2>&1) && export TERM=xterm-256color
  '';
}
