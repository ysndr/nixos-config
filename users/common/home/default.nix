args @ {
  pkgs,
  system,
  nixpkgs_flake,
  ...
}: let
  # comma = pkgs.callPackage (pkgs.fetchgit { url = "https://github.com/nix-community/comma"; sha256 = "sha256-WBIQmwlkb/GMoOq+Dnyrk8YmgiM/wJnc5HYZP8Uw72E="; }) { };
  python = pkgs.python3.withPackages (p:
    with p; [
      numpy
      pandas
      tqdm
    ]);
in rec {
  imports = [../platform/${system}/home.nix ./shell-config.nix ./ssh.nix];

  nixpkgs.config = import ./config.nix;
  xdg.configFile."nixpkgs/config.nix".source = ./config.nix;
  xdg.configFile."nix/nix.conf".text = import ./nix.conf.nix (import ./secrets.nix);
  nix.registry = import ./registry.nix {inherit nixpkgs_flake;};

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    pkgs.nix
    nixpkgs-fmt
    rnix-lsp
    nil
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
    fx
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
    alejandra

    openssh

    tmux

    # fonts
    source-code-pro
    alegreya
    alegreya-sans
    (nerdfonts.override {fonts = ["FiraCode" "DroidSansMono"];})
  ];

  programs = {
    exa = {
      enable = true;
      enableAliases = true;
    };

    git = {
      enable = true;
      delta.enable = true;
    };

    # gpg.enable = true;

    browserpass.enable = true;

    taskwarrior.enable = true;

    home-manager.enable = true;
  };

  home.file.".local/share/task/hooks/on-modify.timewarrior".source = "${pkgs.timewarrior.src}/ext/on-modify.timewarrior";
}
