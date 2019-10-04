{ pkgs, ... }:
let

  nixify = pkgs.nur.repos.kampka.nixify.overrideAttrs(oldAttrs: rec {
      buildInputs = [pkgs.bashInteractive];
      meta = oldAttrs.meta // (with pkgs.stdenv.lib; {
        platforms = platforms.x86_64;
      });
    });

in {
  imports = [./platform.nix];
  home.packages =  with pkgs; [
    # docker_compose
    cachix

    bashInteractive

    gitAndTools.gitflow
    gitAndTools.git

    gopass
    pwgen
    pinentry_mac
    # qtpass

    gnupg
    browserpass


    python3


    jq
    fd
    bat
    ripgrep
    thefuck
    coreutils-full
    xsel

    openssh
    tmux

    # fonts
    source-code-pro
  ];

  fonts.fontconfig.enable = true;

  # programs.command-not-found.enable = true;
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    config = {

    };
    stdlib = pkgs.lib.readFile ./direnv/nix;
  };


  programs.zsh = {
    dotDir = ".config/zsh";
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    shellAliases = {
      shell = "nix-shell";
    };
    history = {
      expireDuplicatesFirst = true;
      extended = true;
    };
    plugins = [
        {
          # will source zsh-autosuggestions.plugin.zsh
          name = "zsh-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "master";
            sha256 = "080ingwxh6c946rqw004imah36ywfp00va844iadnwpnlrvvc8bb";
          };
        }
        {
          name = "nix-zsh-completions";
          src = pkgs.fetchFromGitHub {
            owner = "spwhitt";
            repo = "nix-zsh-completions";
            rev = "f9a6382";
            sha256 = "1nlcglsgb82qp083b1x29vgxq3pgmyrsw6ghbif2jkbn9xibbnz3";
          };
        }
        {
          # will source zsh-autosuggestions.plugin.zsh
          name = "nix-shell";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "master";
            sha256 = "03z89h8rrj8ynxnai77kmb5cx77gmgsfn6rhw77gaix2j3scr2kk";
          };
        }
        {
          # will source zsh-autosuggestions.plugin.zsh
          name = "local";
          src = ./zsh;
        }
      /*{
          name = "enhancd";
          file = "init.sh";
          src = pkgs.fetchFromGitHub {
            owner = "b4b4r07";  
            repo = "enhancd";
            rev = "v2.2.1";
            sha256 = "0iqa9j09fwm6nj5rpip87x3hnvbbz9w9ajgm6wkrd5fls8fn8i5g";
          };
        }
      */
    ];
    oh-my-zsh = {
      custom = "$HOME/.config/zsh";
      enable = true;
      plugins = [
        "git"
        "git-flow"
        "pass"
        "thefuck" 
        "z"
        "fancy-ctrl-z"

        "rust" "cargo" "npm" 

        "nix-shell"
        "nix-zsh-completions"
        "zsh-syntax-highlighting"];
      theme = "robbyrussell";
    };
    profileExtra = ''
      . $HOME/.nix-profile/etc/profile.d/nix.sh
    '';
    initExtra = ''

      local _shell_prompt_info_wrapped

      function _nix_shell_hook {

        _shell_prompt_info=""
        _color=yellow

        if [[ $IN_NIX_SHELL ]] then
          export SHELL=${pkgs.zsh}/bin/zsh
          if [[ $name ]] then
            _shell_prompt_info=$name
          else
            _shell_prompt_info="nix-shell"
          fi
        fi

        if [[ $IN_NIX_SHELL ]] && [[ $DIRENV_DIR ]] then
          _color="green"
        fi

        if [[ $IN_NIX_SHELL ]] then
          _shell_prompt_info="$_shell_prompt_info"
          export SHELL=${pkgs.zsh}/bin/zsh
        fi

        if [[ $_shell_prompt_info ]] then
          _shell_prompt_info_wrapped="%{$fg[$_color]%}($_shell_prompt_info)%{$reset_color%} "
        else
           _shell_prompt_info_wrapped=""
        fi


      }
      add-zsh-hook precmd _nix_shell_hook

      export PROMPT=$\{_shell_prompt_info_wrapped\}$PROMPT



      bindkey "[D" backward-word
      bindkey "[C" forward-word

      test -e "$HOME/.iterm2_shell_integration.zsh" && source "$HOME/.iterm2_shell_integration.zsh"
    '';
  };

  # home manager config
  programs.home-manager.enable = true;
  programs.home-manager.path = https://github.com/rycee/home-manager/archive/master.tar.gz;
}
