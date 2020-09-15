


# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages;
    supportedFilesystems = [ "btrfs" ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };
  hardware.enableAllFirmware = true;
  system.fsPackages = [ pkgs.exfat ];
  
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;  # Enables wireless support via NetworkManager.

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    bash.enableCompletion = true;
    zsh.enable = true;
  };

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
    autorun = false;
    xkbOptions = "eurosign:e";
    # Enable touchpad support.
    libinput = {
      enable = true;
      #clickMethod = "clickfinger";
    };
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };

  fonts = {
    enableDefaultFonts = true;
    fontconfig = {
      defaultFonts = {
        sansSerif = ["Noto Sans Regular" "DejaVu Sans"];
        serif = ["Noto Serif Regular" "DejaVu Serif" ];
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
      plugdev = {};
    };
    users.ysander = {
      isNormalUser = true;
      home = "/home/ysander";
      description = "Yannik Sander";
      extraGroups = [ "wheel" "networkmanager" "audio" "video" "docker" "input" "plugdev" "ysander"];
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
     
    which file tree lsof
    zip unzip
    htop ytop
    psmisc # pstree, killall et al

    curl wget
    gitAndTools.gitFull
    nano
  ];
  environment.pathsToLink = [ "/share/zsh" ];
  
  services.openssh.enable  = true;
  services.openssh.passwordAuthentication = true;
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.09"; # Did you read the comment?

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
