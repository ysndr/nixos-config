{ config, pkgs, ... }:
let
  fontDirectories = [ "/Library/Fonts" "/System/Library/Fonts" "~/Library/Fonts" ];
  fontsConfig = pkgs.makeFontsConf {
    inherit fontDirectories;
  };
  fontsCacheConfig = pkgs.makeFontsCache {
    inherit fontDirectories;
  };
in
{
  home.packages = with pkgs; [
    pinentry_mac
    fontconfig
    fontsCacheConfig

    coreutils-full
    gnugrep
  ];
  programs.zsh = {

    dirHashes = {
      git = "Volumes/projects/git";
    };

    profileExtra = ''
            '';
    initExtra = ''
      export FONTCONFIG_FILE=${fontsConfig}
      export PATH="$PATH:/Users/ysander/Library/Launchers"
      test -e "$HOME/.iterm2_shell_integration.zsh" && source "$HOME/.iterm2_shell_integration.zsh"
    '';
  };
}
