{ ... }:

{

  programs.ssh = {
    enable = true;
    forwardAgent = true;

    matchBlocks = {
      "*" = {
        identityFile = "$HOME/.ssh/gpg_id.pub";
      };
    };
  };

}
