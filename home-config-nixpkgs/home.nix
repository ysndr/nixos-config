{ pkgs, ... }:
let

  nixify = pkgs.nur.repos.kampka.nixify.overrideAttrs(oldAttrs: rec {
      buildInputs = [pkgs.bashInteractive];
      meta = oldAttrs.meta // (with pkgs.stdenv.lib; {
        platforms = platforms.x86_64;
      });
    });

  comma = pkgs.callPackage (fetchGit {url = "https://github.com/Shopify/comma"; }) {};

in {
  imports = [./platform.nix ./shell-config.nix];
  home.packages =  with pkgs; [
    cachix

    bashInteractive

    comma
    gitAndTools.gitflow
    gitAndTools.git

    gopass
    pass
    pwgen

    gnupg
    browserpass


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

    openssh
    tmux

    zoxide fzf

    rsync
    # fonts
    source-code-pro
    joypixels
  ];

  fonts.fontconfig.enable = true;

  programs.gpg.enable = true;

  programs.browserpass.enable = true;

  programs.taskwarrior = {
    enable = true;
  };

  home.file.".local/share/task/hooks/on-modify.timewarrior".source = "${pkgs.timewarrior.src}/ext/on-modify.timewarrior";



  # home manager config
  home.stateVersion = "20.03";
  programs.home-manager.enable = true;
  programs.home-manager.path = https://github.com/rycee/home-manager/archive/master.tar.gz;
}
