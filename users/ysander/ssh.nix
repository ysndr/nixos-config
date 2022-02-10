{...}:

{

  programs.ssh = {
    enable = true;
    forwardAgent = true;
    
    matchBlocks = {
      "*" = {
      	identityFile = "/home/ysander/.ssh/gpg_id.pub";
      };    
    };
  };

}
