args@{ pkgs, platform, ... }:
let

  comma = pkgs.callPackage (pkgs.fetchgit {url = "https://github.com/Shopify/comma"; sha256 = "sha256-IT7zlcM1Oh4sWeCJ1m4NkteuajPxTnNo1tbitG0eqlg="; }) {};

in rec {
  imports = [ "../platform/{platform}/home.nix" ./shell-config.nix ./ssh.nix ];
  
  nixpkgs.config = import ./config.nix;
  xdg.configFile."nixpkgs/config.nix".source = ./config.nix;
  
  home.packages =  with pkgs; [
    cachix

    nixfmt

    comma
    gh    

    gopass
    pass
    pwgen
    
    python3

    jq
    fd
    bat
    exa
    ripgrep
    tealdeer
    thefuck
    
    timewarrior
    xsel

    tmux

    fzf

    rsync
 
    poppler_utils
  ];

  fonts.fontconfig.enable = true;
  
  programs.git = {
    enable =true;
    delta.enable = true;
    userEmail = "me@ysndr.de";
    userName = "ysndr";
  };

  programs.gpg.enable = true;



  programs.browserpass.enable = true;

  programs.taskwarrior = {
    enable = true;
  };

 
  programs.home-manager.enable = true;

  home.file.".local/share/task/hooks/on-modify.timewarrior".source = "${pkgs.timewarrior.src}/ext/on-modify.timewarrior";

 
}
