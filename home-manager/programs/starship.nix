{
  enable = true;
  enableZshIntegration = true;

  # https://starship.rs/config/
    settings = {
      # Get editor completions based on the config schema
      "$schema" = "https://starship.rs/config-schema.json";

      format = "$character $username@$hostname:$directory$git_branch$git_commit$git_metrics$git_status ";

      character = {
        success_symbol = "[󰔶](bold bright-white)";
        error_symbol = "[󰔶](bold red)";
      };
      username = {
        format = "[$user]($style)";
        style_user = "bright-white";
        style_root = "red";
        show_always = true;
      };
      hostname = {
        ssh_only = false;
        format = "[$hostname]($style)";
        style = "bright-white";
      };
      directory = {
        format = "[$path]($style)";
        style = "bright-white";
        truncate_to_repo = false;
      };
      git_branch = {
        format = " [$symbol$branch(:$remote_branch)]($style) ";
        style = "247";
      };
      git_metrics = {
        disabled = false;
        added_style = "green";
        deleted_style = "red";
      };
      git_status = {
        style = "247";
        conflicted = "[=](red)";
        ahead = "[⇡](yellow)";
        behind = "[⇣](yellow)";
        diverged = "[⇕](red)";
        untracked = "[?](yellow)";
        deleted = "[x](red)";
        modified = "[!](yellow)";
        renamed = "[»](yellow)";
        staged = "[+](green)";
      };
      aws.disabled = true;
      gcloud.disabled = true;
      
    };
}
