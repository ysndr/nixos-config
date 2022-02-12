args@{ pkgs, system, nixpkgs_flake, ... }:
let

  # comma = pkgs.callPackage (pkgs.fetchgit { url = "https://github.com/nix-community/comma"; sha256 = "sha256-WBIQmwlkb/GMoOq+Dnyrk8YmgiM/wJnc5HYZP8Uw72E="; }) { };

  python = pkgs.python3.withPackages (p: with p; [
    numpy
    pandas
    tqdm
  ]);


in
rec {
  imports = [ ../platform/${system}/home.nix ./shell-config.nix ./ssh.nix ];

  nixpkgs.config = import ./config.nix;
  xdg.configFile."nixpkgs/config.nix".source = ./config.nix;
  xdg.configFile."nix/nix.conf".source = ./nix.conf;
  nix.registry.nixpkgs.flake = nixpkgs_flake;

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [

    pkgs.nix
    nixpkgs-fmt
    rnix-lsp
    cachix

    # run commands without installing

    # github cli
    gh

    # some password management
    gopass
    gopass-jsonapi
    pass
    pwgen

    # python with some essential programs
    python

    # utilities

    ## use module?
    jq
    bat

    fd
    exa
    ripgrep
    tealdeer
    thefuck
    rsync

    timewarrior
    xsel


    openssh

    tmux

    # fonts
    source-code-pro
    joypixels
    alegreya
    alegreya-sans
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];


  programs = {
    exa = {
      enable = true;
      enableAliases = true;
    };

    git = {
      enable = true;
      delta.enable = true;
      userEmail = "me@ysndr.de";
      userName = "ysndr";
    };

    gpg.enable = true;

    browserpass.enable = true;

    taskwarrior.enable = true;

    home-manager.enable = true;
  };

  home.file.".local/share/task/hooks/on-modify.timewarrior".source = "${pkgs.timewarrior.src}/ext/on-modify.timewarrior";


}
