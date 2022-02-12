{ config, pkgs, ... }:

{

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;


    # Enable the GNOME Desktop Environment.
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;


    # Configure keymap in X11
    layout = "us";
    xkbOptions = "eurosign:e";

  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

  environment.systemPackages = with pkgs; [
    whitesur-gtk-theme
    whitesur-icon-theme
  ];

  services.gnome.chrome-gnome-shell.enable = true;

}
