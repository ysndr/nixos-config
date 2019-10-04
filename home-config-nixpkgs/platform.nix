{ pkgs, ...}:
if builtins.currentSystem == "x86_64-darwin" then
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
        ];
        programs.zsh = {
            initExtra = ''
                export FONTCONFIG_FILE2=${fontsConfig}
                export PATH="$PATH:/Users/ysander/Library/Launchers"
                export FONTCONFIG_FILE=${fontsConfig}
            '';
        };
    }
else if builtins.currentSystem == "x86_64-linux" then
    let

    in {

    }
else {}
