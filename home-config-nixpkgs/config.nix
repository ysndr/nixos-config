{
  allowUnfree = true;
  keep-outputs = true;
  keep-derivations = true;
  packageOverrides = pkgs: rec {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
      repoOverrides = {
        local = import /Volumes/projects/nur-packages {};
        ## remote locations are also possible:
        # mic92 = import (builtins.fetchTarball "https://github.com/your-user/nur-packages/archive/master.tar.gz");
      };
    };
    repos = nur.repos;
    own = nur.repos.ysndr;
    nur-local = nur.repos.local;
  };
}
