# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;  # Enables wireless support via NetworkManager.

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "de";
    defaultLocale = "en_DK.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  #programs.browserpass.enable=true;



  # List services that you want to enable:

  # Enable the OpenSSH daemon. -- ssh handled via gpg
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall.allowedTCPPortRanges = [
    # kdeConnect:
    { from = 1714; to = 1764; }
  ];
  networking.firewall.allowedUDPPortRanges = [
    # kdeConnect:
    { from = 1714; to = 1764; }
  ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };


  # Enable CUPS to print documents.
  services = {
    printing = {
      enable = true;
      browsing = true;
      drivers = [pkgs.unstable.hplip];

    };
    avahi = {
      enable = true;
      nssmdns = true;
    };
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    # keyboard settings
    layout = "de";
    xkbOptions = "eurosign:e";

    # Enable touchpad support.
    libinput.enable = true;
    multitouch = {
      enable=true;
      ignorePalm=true;
    };

    # Enable the KDE Desktop Environment.
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
   # displayManager.sessionCommands = ''
   #     gpg-connect-agent killagent /bye
   #     GPG_TTY=$(tty)
   #     export GPG_TTY
   #   '';
  };

  # include dconf service for gtk applications
  services.dbus.packages = with pkgs; [ gnome3.dconf ];

  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull;
  };

  # MAYBE: Later
  # users.mutableUsers = false

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };

  users.extraGroups = { plugdev = {}; };
  users.extraUsers.ysander = {
    isNormalUser = true;
    home = "/home/ysander";
    description = "Yannik Sander";
    extraGroups = [ "wheel" "networkmanager" "audio" "docker" "input" "plugdev" ];
    shell = "/run/current-system/sw/bin/zsh";
  };


  services.udev.extraRules = ''


  ''
  + builtins.readFile  (./udev/42-logitech-unify-permissions.rules);








  nixpkgs.config = {
    # Allow proprietary packages
    allowUnfree = true;

    # Create an alias for the unstable channel
    packageOverrides = pkgs: {
        unstable = import <nixos-unstable> {
                # pass the nixpkgs config to the unstable alias
                # to ensure `allowUnfree = true;` is propagated:
                config = config.nixpkgs.config;
        };
    };

  };


  environment.systemPackages = with pkgs; [
    coreutils
    utillinux
    linuxPackages.bbswitch
    which
    file
    tree
    lsof
    zip unzip
    htop
    psmisc # pstree, killall et al
    powertop
    hdparm

    zsh oh-my-zsh

    networkmanagerapplet networkmanager_openvpn
    curl wget
#    kdeconnect


    gitAndTools.gitFull
    quilt


    gnupg
    kdeApplications.kleopatra
#    kdeApplications.kgpg
    pass
    pwgen
    pinentry
    pinentry_qt5
    kwalletcli

    # tmux
    xdg_utils
    xfontsel
#    kdeApplications.l10n.de.qt4

    # vim
    nano
    # atom-beta
    unstable.atom
#    libreoffice-fresh

    /* chromium */
    unstable.firefox-bin
    unstable.google-chrome
    # gimp
    # inkscape

    # gtk icons & themes
    gnome3.gtk
    gnome2.gtk
    hicolor_icon_theme
    shared_mime_info

    dunst libnotify
    xautolock
    xss-lock

    nox

  #  plasma-pa

    vlc
    phonon

    kdeApplications.ark
    kdeApplications.spectacle

    # system-config-printer
    xfce.exo
    xfce.gtk_xfce_engine
    xfce.gvfs
    xfce.terminal
    xfce.xfce4icontheme
    xfce.xfce4settings
    xfce.xfconf
  ];

  environment.shellInit = ''

  '';

  #export GTK_PATH=$GTK_PATH:${pkgs.oxygen_gtk}/lib/gtk-2.0
  #export GTK2_RC_FILES=$GTK2_RC_FILES:${pkgs.oxygen_gtk}/share/themes/oxygen-gtk/gtk-2.0/gtkrc


  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "17.09"; # Did you read the comment?



  ## Garbage Collection
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 30d";


}
