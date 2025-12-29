{ pkgs, hostConfig, ... }:

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
  ];
  initContent = pkgs.lib.mkMerge [
    (pkgs.lib.mkOrder 500 ''
# Increment NIX_SHELL_DEPTH each time you enter nix-shell
if [ -n "$IN_NIX_SHELL" ]; then
    export NIX_SHELL_DEPTH=$(( ''${NIX_SHELL_DEPTH:-0} + 1 ))
fi

# Add depth to the prompt
if [ -n "$NIX_SHELL_DEPTH" ]; then
    PS1="[nix-shell depth $NIX_SHELL_DEPTH] $PS1"
fi
    '')
    (pkgs.lib.mkOrder 1000 ''
( [ "$TERM" = "xterm-ghostty" ] || [ "$TERM_PROGRAM" = "ghostty" ] ) && ! $(which ghostty >/dev/null 2>&1) && export TERM=xterm-256color

bindkey -e
  '')
    (if hostConfig.installNode then pkgs.lib.mkOrder 1001 ''
# fnm
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$HOME/.local/share/fnm:$PATH"
  eval "`fnm env --use-on-cd --version-file-strategy=recursive --resolve-engines`"
fi

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
    '' else "")
  ];
}
