{ gitUsername }:

{
  enable = true;

  settings = {
    user = {
      name = "${gitUsername}";
      email = "${gitUsername}@users.noreply.github.com";
    };

    credential.helper = "!gh auth git-credential";
    init.defaultBranch = "main";
    merge.conflictstyle = "diff3";
    diff.colorMoved = "default";
  };
}
