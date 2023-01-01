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
    darwinConfigurations."Yanniks-MacBook-Pro-Intel" = darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [
        ./machines/mbp-2018
      ];
    };

    darwinConfigurations."Yanniks-MacBook-Pro-M1" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./machines/mbp-2021
      ];
    };

    homeConfigurations."ysander@tweag" = home-manager.lib.homeManagerConfiguration rec {
      system = "x86_64-linux";
      homeDirectory = "/home/${username}";
      username = "ysander";
      stateVersion = "21.05";
      extraSpecialArgs = {
        system = "linux";
        nixpkgs_flake = nixpkgs;
      };
      configuration = { ... }: {
        imports = [ ./users/common/home ./users/${username}/home ];
      };
    };

    homeConfigurations."ysander@mbp-2021" =
      let
        username = "ysander";
        system = "aarch64-darwin";
      in
      home-manager.lib.homeManagerConfiguration {
        pkgs = builtins.getAttr system nixpkgs.legacyPackages;
        modules = [
          ./users/common/home
          ./users/${username}/home
          {
            home = {
              username = username;
              homeDirectory = "/Users/${username}";
              stateVersion = "21.11";
            };
          }
        ];

        extraSpecialArgs = {
          system = "darwin";
          nixpkgs_flake = nixpkgs;
        };
      };

    homeConfigurations."yannik@mbp-2021" =
      let
        username = "yannik";
        system = "aarch64-darwin";
      in
      home-manager.lib.homeManagerConfiguration {
        pkgs = builtins.getAttr system nixpkgs.legacyPackages;
        modules = [
          ./users/common/home
          ./users/${username}/home
          {
            home = {
              username = username;
              homeDirectory = "/Users/${username}";
              stateVersion = "21.11";
            };
          }
        ];

        extraSpecialArgs = {
          system = "darwin";
          nixpkgs_flake = nixpkgs;
        };
      };

    packages = nixpkgs.lib.genAttrs [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ] (arch: home-manager.packages."${arch}");

  };
}
