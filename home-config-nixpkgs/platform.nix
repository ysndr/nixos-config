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
        home.packages = with pkgs; [
            atom
            evince
            firefox
            gitkraken
            gnome3.eog
            gnome3.gnome-tweak-tool
            google-chrome
            kmail
            pulseeffects
            qtpass
            spotify
            tdesktop     
            typora
            vscode

            docker_compose

            libinput-gestures

            ksshaskpass

            hunspellDicts.de-de
            hunspellDicts.en-us
        ];

        programs.zsh.shellAliases = {
            open = "xdg-open";
        };

        services.gpg-agent = {
            enable = true;
            enableSshSupport = true;
            defaultCacheTtl = 3600;
            extraConfig = ''
            pinentry-program ${pkgs.pinentry}/bin/pinentry
            '';
        };

        services.redshift = {
            enable = true;
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

    }
else {}
