{ pkgs, ... }:
let
  unstable = import <nixos-unstable> {};
  master = import <master> {};
  fork = import ~/programs/nix/nixpkgs {};


  channels = {
    pkgs = with pkgs; [

      latte-dock
      ark
      spectacle
      kgpg
      
      firefox
      atom
      vscode
      kmail
      spotify
      tdesktop     

      docker_compose

      #atom

      git-cola
      gitAndTools.gitflow

      gksu

      libinput-gestures

      pass
      pwgen
      ksshaskpass
      /* pinentry */
      qtpass

      gnupg

      evince
      gnome3.eog

      hunspellDicts.de-de
      hunspellDicts.en-us


      python3


      jq
      fd
      ripgrep
      thefuck
      xsel



      # fonts
      fira-code



    ];
    unstable =  with unstable; [
    ];
    master = with master; [
#      krunner-pass
    ];
    other = [fork.kwalletcli fork.solaar];
  };
in {
  home.packages = channels.pkgs
               ++ channels.unstable
               ++ channels.master
	             ++ channels.other;

  fonts.fontconfig.enableProfileFonts = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 3600;
    extraConfig = ''
    pinentry-program ${pkgs.pinentry_qt5}/bin/pinentry
    '';
  };
  services.redshift = {
    enable = true;
    latitude = "52.01667";
    longitude = "8.51667";
    temperature = {
      day = 6000;
      night = 4500;
    };
    brightness = {
      day = "1";
      night = "0.5";
    };
    tray = true;
  };


  services.kdeconnect.enable = true;
  services.keybase.enable = true;

  programs.command-not-found.enable = true;

  programs.zsh = {
    dotDir = ".config/zsh";
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    shellAliases = {
      open = "xdg-open";
      shell = "nix-shell";
    };
    history = {
      expireDuplicatesFirst = true;
      extended = true;
    };
    plugins = [
      /* {
          name = "enhancd";
          file = "init.sh";
          src = pkgs.fetchFromGitHub {
            owner = "b4b4r07";
            repo = "enhancd";
            rev = "v2.2.1";
            sha256 = "0iqa9j09fwm6nj5rpip87x3hnvbbz9w9ajgm6wkrd5fls8fn8i5g";
          };
        } */

    ];
    oh-my-zsh = {
      custom = "$HOME/.config/zsh/oh-my-zsh";
      enable = true;
      plugins = ["git" "docker" "thefuck" "z" "rust" "cargo" "fancy-ctrl-z" "nix" "nix-shell" "git-flow-completion" ];
      theme = "robbyrussell";
    };
    initExtra = ''
      [[ $IN_NIX_SHELL ]] && PROMPT="%{$fg[yellow]%}(nix-shell)%{$reset_color%} $PROMPT"
    '';
  };


  # home manager config
  programs.home-manager.enable = true;
  programs.home-manager.path = https://github.com/rycee/home-manager/archive/master.tar.gz;
}
