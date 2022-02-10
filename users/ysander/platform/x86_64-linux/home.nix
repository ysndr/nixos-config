{ config, pkgs, ... }:
let
in {
        i18n.inputMethod = {
                enabled = "fcitx";
		fcitx.engines = with pkgs.fcitx-engines; [ cloudpinyin libpinyin];
	};

        home.packages = with pkgs; [
            albert
            alacritty
            evince
            gitkraken
            gnome3.eog
#            gnome3.evolution
            gnome3.gnome-tweak-tool
            google-chrome
            kmail
            mdcat
            qtpass
            spotify
            tdesktop     
            tilix
            vscode

            docker_compose

            hunspellDicts.de-de
            hunspellDicts.en-us

            noto-fonts
            noto-fonts-emoji
            emojione
            fira-code
            fira-code-symbols

	    yaru-theme
        ];

        programs.firefox = {
          enable=true;
          package = pkgs.firefox.override {
            # See nixpkgs' firefox/wrapper.nix to check which options you can use
            cfg = {
            # Gnome shell native connector
              enableGnomeExtensions = true;
            };
          };  
        };


        programs.zsh = {
          enableVteIntegration = true;
          shellAliases = {
            open = "xdg-open";
          };
        };

        services.gpg-agent = {
            enable = true;
            enableSshSupport = true;
            enableExtraSocket = true;
            defaultCacheTtl = 3600;
            
            sshKeys = [
            	"442D005A51D0FA60BC6F6E1C37239F49A8A466D5"
            ];
            
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

        services.kdeconnect.enable = true;

    }
