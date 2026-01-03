{ pkgs, ... }: {
    imports = [
        ../../modules/nixos/overlays/stremio-service.nix
        ../../modules/nixos/programs/niri.nix
        ../../modules/nixos/programs/zsh.nix
        ../../modules/nixos/services/navidrome.nix
    ];

    users.users.ale = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" ];
        shell = pkgs.zsh;
    };
}
