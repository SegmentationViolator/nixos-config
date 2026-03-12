{ pkgs, ... }: {
    imports = [
        ../../modules/programs/fragments.nix
        ../../modules/programs/niri.nix
        ../../modules/programs/zsh.nix
    ];

    users.users.ale = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" ];
        shell = pkgs.zsh;
    };
}
