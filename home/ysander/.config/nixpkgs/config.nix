{
  allowUnfree = true;
  packageOverrides = super: rec {
    steam-chrootenv = steam-chrootenv.override {
      withPrimus = true;
    };
    steam = super.steam.override {
      withPrimus = true;
      extraPkgs = p: with p; [
        glxinfo        # for diagnostics
        nettools       # for `hostname`, which some scripts expect
        bumblebee      # for optirun
      ];
    };
    
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      pkgs=super;
    };
  };
  firefox = {
    enableAdobeFlash = true;
    ffmpegSupport = true;
    gssSupport = true;
    /* jre = true; */
    /* enableMPlayer = true; */
    enableDjvu = true;
    enablePlasmaBrowserIntegration = true;
    enableBrowserpass = true;
  };
}
