{
    description = "NixOS configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        nvf-config = {
            url = "github:SegmentationViolator/nvf-config";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { nixpkgs, nvf-config, ... }: {
        nixosConfigurations = {
            segmented-box = nixpkgs.lib.nixosSystem {
                modules = [ ./hosts/segmented-box ];
            };

            segmented-usb = nixpkgs.lib.nixosSystem {
                modules = [ ./hosts/segmented-usb ];
                specialArgs = { inherit nvf-config; };
            };
        };
    };
}
