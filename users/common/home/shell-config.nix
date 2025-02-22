{pkgs, ...}: let
  dircolors_src = pkgs.fetchgit {
    url = "https://github.com/trapd00r/LS_COLORS";
    sha256 = "sha256-MVESURX3tNHxnFiLCJIlKOCLbXeoz4OBGzuoRZiurb8=";
  };
in {
  programs = {
    bash.enable = true;
    atuin = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      flags = ["--disable-up-arrow"];
      settings = {
        style = "compact";
        show_preview = true;
      };      
    };    
    
    fzf = {
      enableBashIntegration = true;
      enableZshIntegration = true;
      enable = true;
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv = {
        enable = true;
      };
      config = {};
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      settings = {
        add_newline = false;
        status = {
          disabled = false;
          symbol = "⚡️";
          map_symbol = true; # breaks shells :(
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
      enableNushellIntegration = true;
    };

    carapace = {
      enable = true;
      enableNushellIntegration = false;
      enableZshIntegration = false;
    };

    dircolors = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };

    eza = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };

    zsh = {
      dotDir = ".config/zsh";
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      autosuggestion.enable = false;

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
        ];
      };

      profileExtra = ''
        source $HOME/.nix-profile/etc/profile.d/nix.sh
      '';

      initExtra = ''
        bindkey "[D" backward-word
        bindkey "[C" forward-word

        export SHELL=${pkgs.zsh}/bin/zsh
      '';
    };

    fish = {
      enable = true;
    };

    nushell = {
      enable = true;
      extraConfig = ''
        $env.SHLVL = ($env.SHLVL | default 0 | into int) + 1

        ${builtins.readFile ./nushell/complete.nu}
      '';
    };
  };
}
