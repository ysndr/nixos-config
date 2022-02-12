{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, darwin }: {

    nixosConfigurations."tweag" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [
          ./machines/tweag
          ./users/ysander

          (import ./common { inherit nixpkgs; })
          ({ pkgs, ... }: {
            # Let 'nixos-version --json' know about the Git revision
            # of this flake.
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
          })
          # home-manager.nixosModules.home-manager {
          #   home-manager.useGlobalPkgs = true;
          #   home-manager.useUserPackages = true;
          #   home-manager.users.ysander = import ./users/ysander/home;
          #   home-manager.extraSpecialArgs = {
          #     platform = ./platform/x86_64-linux/home.nix; 
          #   }
          # }
        ];
    };


    # activate with:
    #
    # $ nix build ~/.config/darwin\#darwinConfigurations.Johns-MacBook.system
    # $ ./result/sw/bin/darwin-rebuild switch --flake ~/.config/darwin
    ###
    darwinConfigurations."Yanniks-MacBook-Pro" = darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [ 
        ./machines/mbp-2018
      ];
    };

    homeConfigurations."ysander@tweag" = home-manager.lib.homeManagerConfiguration rec {
      system = "x86_64-linux";
      homeDirectory = "/home/${username}";
      username = "ysander";
      stateVersion = "21.05";
      extraSpecialArgs = {
        inherit system;
        nixpkgs_flake = nixpkgs;
      };
      configuration = { ... }: {
        imports = [ ./users/${username}/home ];
      };
    };

    homeConfigurations."ysander@mbp-2018" = home-manager.lib.homeManagerConfiguration rec {
      system = "x86_64-darwin";
      username = "ysander";
      homeDirectory = "/Users/${username}";
      stateVersion = "21.05";
      extraSpecialArgs = {
        inherit system;
        nixpkgs_flake = nixpkgs;
      };
      configuration = { ... }: {
        imports = [ ./users/${username}/home ];
      };
    };

    packages = {
      "x86_64-linux" = home-manager.packages."x86_64-linux";
      "x86_64-darwin" = home-manager.packages."x86_64-darwin";
    };

    apps = {
      x86_64-darwin = home-manager.apps."x86_64-darwin";
      x86_64-linux = home-manager.apps."x86_64-linux";
    };

  };
}
