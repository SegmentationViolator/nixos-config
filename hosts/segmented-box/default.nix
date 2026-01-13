{ pkgs, nvf-config, ... }:

{
    imports = [
        ../../modules/nixos/bootloader/systemd-boot.nix
        ../../modules/nixos/hardware/backlight.nix
        ../../modules/nixos/hardware/networking.nix
        ../../modules/nixos/hardware/nvidia.nix
        ../../modules/nixos/hardware/sound.nix
        ../../modules/nixos/nixpkgs/unfree.nix
        ../../modules/nixos/security/doas.nix
        ../../modules/nixos/services/power-management.nix
        ./hardware-configuration.nix
    ];

    boot.kernelPackages = pkgs.linuxPackages_latest;

    environment.systemPackages = with pkgs; [
        bat
        eza
        git
        unzip
    ];

    i18n.defaultLocale = "en_US.UTF-8";

    networking = {
        firewall = {
            allowedTCPPorts = [
                # developmennt web server
                8000 8080
                # for BitTorrent client
                51413
            ];
        };
        hostName = "segmented-box";
    };

    programs.neovim = {
        enable = true;
        defaultEditor = true;
        package = nvf-config.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };

    services.actkbd.enable = true;

    time.timeZone = "Asia/Kolkata";

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    system.stateVersion = "26.05";
}
