






{ pkgs, ...}:
let
dircolors_src = (fetchGit {
  url = "https://github.com/trapd00r/LS_COLORS";
});
in
{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    config = {

    };
    stdlib = pkgs.lib.readFile ./direnv/nix;
    # stdlib = builtins.fetchurl "https://raw.githubusercontent.com/nix-community/nix-direnv/master/direnvrc";
  };
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      nix_shell.use_name = true;
    };
  };
  programs.zsh = {
    dotDir = ".config/zsh";
    enable = true;
    enableCompletion = false;
    enableAutosuggestions = true;
    shellAliases = {
      ls = "ls --color=auto";
      shell = "nix-shell";
      weather = "curl wttr.in/\\";
      nb = "jupyter notebook";
    };
    history = {
      expireDuplicatesFirst = true;
      extended = true;
    };
    plugins = [

        {
          name = "zsh-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "master";
            sha256 = "sha256:0s1cjm8psjwmrg8qdhdg48qyvp8nqk7bdgvqivgc5v9m27m7h5cg";
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
          name = "nix-shell";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "master";
            sha256 = "sha256:0snhch9hfy83d4amkyxx33izvkhbwmindy0zjjk28hih1a9l2jmx";
          };
        }
	/*
        {
          name = "timewarrior";
          src = pkgs.fetchFromGitHub {
            owner = "svenXY";
            repo = "timewarrior";
            rev = "master";
            sha256 = "sha256:0qqrvsa4yb4xck3s6ha9j4kn0kg3ik1jkb4m57nbvq1y8wm1vlga";
          };
        }
	*/
        /*
        {
          name = "taskwarrior";
          src = "${pkgs.taskwarrior.src}/scripts/zsh";
        }
        */
        {
          name = "local";
          src = ./zsh/local;
        }
    ];
    oh-my-zsh = {
      custom = "$HOME/.config/zsh";
      enable = true;
      plugins = [
        "git"
        "git-flow"
        "thefuck"
        "fancy-ctrl-z"
#        "timewarrior"
        "rust" "cargo" "npm"

        "nix-shell"
        "fd"
        ];
      theme = "robbyrussell";
    };

    profileExtra = ''
      [[ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]] && source $HOME/.nix-profile/etc/profile.d/nix.sh
    '';

    initExtra = ''
      bindkey "[D" backward-word
      bindkey "[C" forward-word

      export SHELL=${pkgs.zsh}/bin/zsh

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

      export PROMPT="$_shell_prompt_info_wrapped$PROMPT"

      eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"
      eval "$(${pkgs.coreutils}/bin/dircolors -b ${dircolors_src}/LS_COLORS)"
    '';
  };
}
