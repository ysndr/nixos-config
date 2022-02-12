# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true; # Enables wireless support via NetworkManager.

  # Select internationalisation properties.
  console.font = "Lat2-Terminus16";
  #  console.keyMap = "en_US";


  i18n = {
    defaultLocale = "en_SE.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    bash.enableCompletion = true;
    qt5ct.enable = true;
    zsh.enable = true;
    browserpass.enable = true;
  };
  # programs.mtr.enable = true;




  system.fsPackages = [ pkgs.exfat ];


  # List services that you want to enable:

  # Open ports in the firewall.

  networking.firewall.enable = false;


  # Enable Docker

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  # Enable CUPS to print documents.
  /**
    services = {
    printing = {
    enable = true;
    browsing = true;
    drivers = [pkgs.hplip];

    };
    avahi = {
    enable = true;
    nssmdns = true;
    };
    };
  */

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    # keyboard settings
    #    layout = "en";
    xkbOptions = "eurosign:e";

    # Enable touchpad support.
    libinput = {
      enable = true;
      #clickMethod = "clickfinger";
    };


    # Enable the KDE Desktop Environment.
    # displayManager.sddm.enable = true;
    displayManager.gdm.enable = false;
    # desktopManager.plasma5.enable = true;
    desktopManager.gnome3.enable = true;

  };

  services.gnome3 = {
    gnome-keyring.enable = true;
    chrome-gnome-shell.enable = true;
  };

  # include dconf service for gtk applications
  services.dbus.packages = with pkgs; [ gnome3.dconf ];



  fonts = {
    enableDefaultFonts = true;
    fontconfig = {
      defaultFonts = {
        sansSerif = [ "Noto Sans Regular" "DejaVu Sans" ];
        serif = [ "Noto Serif Regular" "DejaVu Serif" ];
        monospace = [ "Fira Code" "DejaVu Sans Mono" ];
      };
      enable = true;
      useEmbeddedBitmaps = true;
    };
  };

  # MAYBE: Later
  # users.mutableUsers = false

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };

  users = {
    groups = {
      plugdev = { };
      ysander = {
        gid = 1001;
      };
    };
    users.ysander = {
      isNormalUser = true;
      home = "/home/ysander";
      description = "Yannik Sander";
      extraGroups = [ "wheel" "networkmanager" "audio" "video" "docker" "input" "plugdev" "ysander" ];
      shell = "/run/current-system/sw/bin/zsh";
    };
  };





  nixpkgs.config = {
    # Allow proprietary packages
    allowUnfree = true;

    # Create an alias for the unstable channel
    packageOverrides = pkgs: {
      nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
    };

  };


  environment.systemPackages = with pkgs; [
    coreutils
    utillinux

    which
    file
    tree
    lsof
    zip
    unzip
    htop
    psmisc # pstree, killall et al

    curl
    wget
    #    kdeconnect


    gitAndTools.gitFull
    quilt

    xdg_utils
    xfontsel

    nano

    firefox


    # gtk icons & themes
    gnome3.gtk
    gnome2.gtk
    hicolor_icon_theme
    shared_mime_info
    arc-theme

    nox

    zsh

  ];
  environment.pathsToLink = [ "/share/zsh" ];

  services.openssh.enable = true;
  services.openssh.passwordAuthentication = true;
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?


  nix = {

    ## Garbage Collection
    gc.automatic = true;
    gc.dates = "weekly";
    gc.options = "--delete-older-than 30d";

    binaryCaches = [
      "https://cache.nixos.org/"
    ];
    binaryCachePublicKeys = [

    ];
    trustedUsers = [ "root" "ysander" ];
  };
}
