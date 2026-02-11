{
    description = "NixOS configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    };

    outputs = { nixpkgs, ... }: {
        nixosConfigurations = {
            segmented-box = nixpkgs.lib.nixosSystem {
                modules = [ ./hosts/segmented-box ];
            };
        };
    };
}
