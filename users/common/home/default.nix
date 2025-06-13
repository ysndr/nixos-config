args@{
  pkgs,
  system,
  nixpkgs_flake,
  ...
}:
let
  # comma = pkgs.callPackage (pkgs.fetchgit { url = "https://github.com/nix-community/comma"; sha256 = "sha256-WBIQmwlkb/GMoOq+Dnyrk8YmgiM/wJnc5HYZP8Uw72E="; }) { };
  python = pkgs.python3.withPackages (
    p: with p; [
      numpy
      pandas
      tqdm
    ]
  );
in
rec {
  imports = [
    ../platform/${system}/home.nix
    ./shell-config.nix
    ./ssh.nix
  ];

  nixpkgs.config = import ./config.nix;
  xdg.configFile."nixpkgs/config.nix".source = ./config.nix;
  xdg.configFile."nix/nix.conf".text = import ./nix.conf.nix (import ./secrets.nix);
  nix.registry = import ./registry.nix { inherit nixpkgs_flake; };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    pkgs.nix
    nixfmt-rfc-style
    nil
    cachix

    # run commands without installing

    # github cli
    gh
    git-absorb

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
    eza
    ripgrep
    tealdeer
    thefuck
    rsync
    timewarrior
    xsel
    alejandra
    nixfmt-rfc-style

    openssh

    tmux

    # fonts
    source-code-pro
    # joypixels unfree
    alegreya
    alegreya-sans
    nerd-fonts."fira-code"
    nerd-fonts."droid-sans-mono"
  ];

  programs = {
    git = {
      enable = true;
      # delta.enable = true;
      difftastic.enable = true;
      extraConfig = {
        push.autoSetupRemote = true;
        safe.directory = "*";
        filter.lfs.smudge = "git-lfs smudge -- %f";
        filter.lfs.clean = "git-lfs clean -- %f";
        filter.lfs.process = "git-lfs filter-process";
        filter.lfs.required = true;
      };

    };

    # gpg.enable = true;

    browserpass.enable = true;

    #taskwarrior.enable = true;

    helix = {
      enable = true;
      defaultEditor = true;
      settings = {
        theme = "base16_transparent";
        editor = {
          scroll-lines = 1;
          cursor-shape = {
            normal = "underline";
            insert = "bar";
            select = "block";
          };
          lsp = {
            display-inlay-hints = true;
          };
          auto-save = {
            focus-lost = true;
          };
          # indent-guides = {
          #   render = true;
          #   character = "";
          # };
        };
      };
      languages = {
        language = [
          {
            name = "rust";

            auto-pairs = {
              "(" = ")";
              "{" = "}";
              "[" = "]";

              "\"" = "\"";
              "`" = "`";
              "<" = ">";
            };
          }
        ];
      };
    };

    home-manager.enable = true;
  };

  # home.file.".local/share/task/hooks/on-modify.timewarrior".source = "${pkgs.timewarrior.src}/ext/on-modify.timewarrior";
}
