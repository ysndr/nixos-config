{ pkgs, ...}:
let
dircolors_src = (pkgs.fetchgit {
  url = "https://github.com/trapd00r/LS_COLORS";
sha256 = "sha256-46UR3lKOAoMdcIolVzyqMyGs+Q2DXeq7xUubTLxS3/I=";
});
in
{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv = {
      enable = true;
      enableFlakes = true;
    };
    config = {

    };
    # stdlib = pkgs.lib.readFile ./direnv/nix;
  };
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
    };
  };
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
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
            sha256 = "sha256-vwtgFWEs51ZfrUbWmRjcHZz+WPMFUrSHfIt4FjrMOoU=";
          };
        }
        {
          name = "nix-zsh-completions";
          src = pkgs.fetchFromGitHub {
            owner = "spwhitt";
            repo = "nix-zsh-completions";
            rev = "f9a6382";
            sha256 = "sha256-S5N00uVYF79naaohVZA8+Y5nPRocaDCWOKjlyu5bry4=";
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
        # {
        #   name = "nix-zsh-completions";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "spwhitt";
        #     repo = "nix-zsh-completions";
        #     rev = "f9a6382";
        #     sha256 = "1nlcglsgb82qp083b1x29vgxq3pgmyrsw6ghbif2jkbn9xibbnz3";
        #   };
        # }
        */
        {
          name = "timewarrior";
          src = pkgs.fetchFromGitHub {
            owner = "svenXY";
            repo = "timewarrior";
            rev = "master";
            sha256 = "sha256-S5N00uVYF79naaohVZA8+Y5nPRocaDCWOKjlyu5bry4=";
          };
        }
        #{
        #  name = "taskwarrior";
        #  src = "${pkgs.taskwarrior}/scripts/zsh";
        #}
        {
          name = "local";
          src = ./zsh/local;
        }
        # {
        #   # will source zsh-autosuggestions.plugin.zsh
        #   name = "nix-shell";
        #   src = ./zsh/nix-shell;
        # }
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
        "thefuck"
        "fancy-ctrl-z"
        "timewarrior"
        "rust" "cargo" "npm"
        "nix-shell"
        "fd"
        ];
      theme = "robbyrussell";
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
  # unset system set (i.e. gnome keyring) AUTH_SOCK so gpg can override it
  home.sessionVariables.SSH_AUTH_SOCK = "";
}
