{
<<<<<<< HEAD
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:NotAShelf/nvf/v0.8";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nvf, ... }:
  {
    nixosConfigurations.segmentedbox = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.ale = users/ale/home.nix;
        }
        nvf.nixosModules.default
      ];
    };
  };
=======
    description = "NixOS configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        nur = {
            url = "github:nix-community/NUR";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        matugen = {
            url = "github:/InioX/Matugen";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nix-index-database = {
            url = "github:nix-community/nix-index-database";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nvf-config = {
            url = "github:SegmentationViolator/nvf-config";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { nixpkgs, nur, home-manager, matugen, nix-index-database, nvf-config, ... }: {
        nixosConfigurations = {
            segmented-box = nixpkgs.lib.nixosSystem {
                modules = [
                    ./hosts/segmented-box
                    ./users/ale

                    home-manager.nixosModules.home-manager {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
                        home-manager.users.ale = ./users/ale/home.nix;
                        home-manager.extraSpecialArgs = { inherit matugen nix-index-database; };
                    }

                    nur.modules.nixos.default
                ];

                specialArgs = { inherit nvf-config; };
            };

            segmented-usb = nixpkgs.lib.nixosSystem {
                modules = [
                    ./hosts/segmented-usb

                    home-manager.nixosModules.home-manager {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
                    }

                    nur.modules.nixos.default
                ];

                specialArgs = { inherit nvf-config; };
            };
        };
    };
>>>>>>> nixos-config/master
}
