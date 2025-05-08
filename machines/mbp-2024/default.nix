{
  config,
  pkgs,
  ...
}:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    pkgs.coreutils
    pkgs.openssh
    pkgs.pinentry_mac
    pkgs.gnupg
  ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.logFile =

  programs.zsh.enable = true;

  users.knownUsers = [ "homebrewer" ];
  users.groups.homebrewer = {
    members = [
      "homebrewer"
      "yannik"
    ];
  };
  users.users.homebrewer = {
    uid = 599;
    isHidden = true;
    home = "/opt/homebrew";
  };
  environment.systemPath = [ "/opt/homebrew/bin" ];

  
  security.pam.services.sudo_local.touchIdAuth = true;

  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  fonts.packages = [ ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # You should generally set this to the total number of logical cores in your system.
  # $ sysctl -n hw.ncpu
  nix.settings.max-jobs = 10;
  nix.settings.cores = 10;
  nix.settings.trusted-users = [
    "root"
    "ysander"
    "yannik"
  ];
}
