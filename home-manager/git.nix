{ gitUsername }:

{
    enable = true;

    userName = "${gitUsername}";
    userEmail = "${gitUsername}@users.noreply.github.com";

    delta = {
      enable = true;
      options = {
        diff-highlight = true;
	line-numbers = true;
        side-by-side = true;
      };
    };

    extraConfig = {
      credential.helper = "!gh auth git-credential";
      init.defaultBranch = "main";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
    };
}
