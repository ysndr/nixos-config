
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

            coreutils-full
            gnugrep
        ];
        programs.zsh = {
            profileExtra=''
            '';
            initExtra = ''
                export FONTCONFIG_FILE=${fontsConfig}
                export PATH="$PATH:/Users/ysander/Library/Launchers"
                test -e "$HOME/.iterm2_shell_integration.zsh" && source "$HOME/.iterm2_shell_integration.zsh"
            '';
        };
    }
else if builtins.currentSystem == "x86_64-linux" then
    let

    in {
        home.packages = with pkgs; [
            mdcat
            pulseeffects
            docker_compose

            hunspellDicts.de-de
            hunspellDicts.en-us

            noto-fonts
            noto-fonts-emoji
            emojione
            fira-code
            fira-code-symbols

        ];

        programs.zsh.shellAliases = {
            open = "xdg-open";
        };

        services.gpg-agent = {
            enable = true;
            enableSshSupport = true;
            defaultCacheTtl = 3600;
	    pinentryFlavor = "curses";
            extraConfig = ''
            '';
        };

        services.redshift = {
            enable = false;
            latitude = "52.01667";
            longitude = "8.51667";
            temperature = {
                day = 6500;
                night = 4500;
            };
            brightness = {
                day = "1";
                night = "0.4";
            };
            tray = true;
        };

        services.keybase.enable = true;
        services.syncthing = {
            enable = true;
            tray = true;
        };
    }
else {}
