{ pkgs, ... }:
let
  dircolors_src = (pkgs.fetchgit {
    url = "https://github.com/trapd00r/LS_COLORS";
    sha256 = "sha256-MVESURX3tNHxnFiLCJIlKOCLbXeoz4OBGzuoRZiurb8=";
  });
in
{
  programs = {

    bash.enable = true;
    fzf.enable = true;

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv = {
        enable = true;
      };
      config = { };
      # stdlib = pkgs.lib.readFile ./direnv/nix;
    };

    skim = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
        status = {
          disabled = false;
          map_symbol = true;
          pipestatus = true;
        };
        cmd_duration.show_notifications = true;
        git_metrics = {
          disabled = false;
          format = "[+$added]($added_style)/[-$deleted]($deleted_style)";
        };
        git_status = {
          ahead = ''⇡''${count}'';
          diverged = ''⇕⇡''${ahead_count}⇣''${behind_count}'';
          behind = ''⇣''${count}'';
        };
        shlvl = {
          symbol = "↕ ";
          disabled = false;
        };
        sudo.disabled = true;
      };
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    zsh = {
      dotDir = ".config/zsh";
      enable = true;
      enableCompletion = false;
      enableSyntaxHighlighting = true;
      enableAutosuggestions = true;

      dirHashes = {
        docs = "$HOME/Documents";
        dl = "$HOME/Downloads";
      };

      shellAliases = {
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
          name = "nix-shell";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "master";
            sha256 = "sha256:0snhch9hfy83d4amkyxx33izvkhbwmindy0zjjk28hih1a9l2jmx";
          };
        }
        {
          name = "timewarrior";
          src = pkgs.fetchFromGitHub {
            owner = "svenXY";
            repo = "timewarrior";
            rev = "master";
            sha256 = "sha256-S5N00uVYF79naaohVZA8+Y5nPRocaDCWOKjlyu5bry4=";
          };
        }
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
          "timewarrior"
          "rust"
          "npm"
          "nix-shell"
          "fd"
        ];
      };

      profileExtra = ''
        source $HOME/.nix-profile/etc/profile.d/nix.sh
      '';

      initExtra = ''
        bindkey "[D" backward-word
        bindkey "[C" forward-word

        export SHELL=${pkgs.zsh}/bin/zsh

        eval "$(${pkgs.coreutils}/bin/dircolors -b ${dircolors_src}/LS_COLORS)"
      '';
    };
  };
}
