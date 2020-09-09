{
  allowUnfree = true;
  keep-outputs = true;
  keep-derivations = true;
  packageOverrides = pkgs: rec {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
      repoOverrides = {
        local = import /Volumes/projects/nur-packages { inherit pkgs; };
        ## remote locations are also possible:
        # mic92 = import (builtins.fetchTarball "https://github.com/your-user/nur-packages/archive/master.tar.gz");
      };
    };
    repos = nur.repos;
    own = nur.repos.ysndr;
    nur-local = nur.repos.local;
  };
} // (if builtins.currentSystem == "x86_64-linux" then {
  packageOverrides = super: rec {
    steam = super.steam.override {
      withPrimus = true;
      extraPkgs = p: with p; [
        glxinfo        # for diagnostics
        nettools       # for `hostname`, which some scripts expect
        # bumblebee      # for optirun
      ];
    };
  };
  
  firefox = {
    ffmpegSupport = true;
    gssSupport = true;
    /* jre = true; */
    /* enableMPlayer = true; */
    enableGnomeExtensions = true;
    enableDjvu = true;
    enablePlasmaBrowserIntegration = true;
    enableBrowserpass = true;
  };
  android_sdk.accept_license = true;

} else {})
