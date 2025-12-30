{ hostConfig, ... }:
{
  enable = true;
  enableZshIntegration = true;
  globalConfig = {
    env._.file = ".env.local";
    tools = if hostConfig.installNode then {
      node = "lts";
      pnpm = "latest";
    } else {};
  };
}
