{ pkgs, hostConfig }:

let
  baseList = with pkgs; [
    delta
    gh
    tmux
    # fzf / ripgrep / bat / nvim script
    (pkgs.writeScriptBin "rfv" ''
#!/bin/bash
# Switch between Ripgrep launcher mode (CTRL-R) and fzf filtering mode (CTRL-F)
rm -f /tmp/rg-fzf-{r,f}
RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
INITIAL_QUERY="''${*:-}"
fzf --ansi --disabled --query "''$INITIAL_QUERY" \
    --bind "start:reload(''$RG_PREFIX {q})+unbind(ctrl-r)" \
    --bind "change:reload:sleep 0.1; ''$RG_PREFIX {q} || true" \
    --bind "ctrl-f:unbind(change,ctrl-f)+change-prompt(2. fzf> )+enable-search+rebind(ctrl-r)+transform-query(echo {q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f)" \
    --bind "ctrl-r:unbind(ctrl-r)+change-prompt(1. ripgrep> )+disable-search+reload(''$RG_PREFIX {q} || true)+rebind(change,ctrl-f)+transform-query(echo {q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r)" \
    --color "hl:-1:underline,hl+:-1:underline:reverse" \
    --prompt '1. ripgrep> ' \
    --delimiter : \
    --header '╱ CTRL-R (ripgrep mode) ╱ CTRL-F (fzf mode) ╱' \
    --preview 'bat --color=always {1} --highlight-line {2}' \
    --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
    --bind 'enter:become(vim {1} +{2})'
'')
  ];
in
  # Additional packages for non-headless setups.
  baseList ++ (if hostConfig.isHeadless then [] else (
    if hostConfig.isNixStable then [
      (pkgs.nerdfonts.override { fonts = [
        "JetBrainsMono"
        # Fonts are super large.  Enable as needed.
        #"FiraCode"
        #"GeistMono"
        #"Noto"
      ]; } )
    ] else [
      pkgs.nerd-fonts.jetbrains-mono
      #pkgs.nerd-fonts.fira-code
      #pkgs.nerd-fonts.geist-mono
      #pkgs.nerd-fonts.noto
    ])
  )
