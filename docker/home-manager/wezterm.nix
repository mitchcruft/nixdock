{
  enable = true;
  extraConfig = (builtins.readFile ./config/wezterm.lua);
}
