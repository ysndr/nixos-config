{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, home-manager }: {

    nixosConfigurations."tweag" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [ ./machines/tweag
          ./machines/mbp-2018

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
    
    homeConfigurations."ysander@tweag" = home-manager.lib.homeManagerConfiguration rec {
    	system = "x86_64-linux";
    	homeDirectory = "/home/${username}";
    	username = "ysander";
    	stateVersion = "21.05";
    	extraSpecialArgs = {
          inherit system;
          nixpkgs_flake = nixpkgs;
        };
    	configuration = {...}: {
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
    	configuration = {...}: {
    	 imports = [ ./users/${username}/home ];
    	};
    };
    
    packages = {
      "x86_64-linux" = home-manager.packages."x86_64-linux";
      "x86_64-darwin" = home-manager.packages."x86_64-darwin";
    };

    apps = home-manager.apps;

  };
}
