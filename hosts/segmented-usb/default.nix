{ pkgs, nvf-config, ... }:

{
    imports = [
        ../../modules/nixos/bootloader/systemd-boot.nix
        ../../modules/nixos/hardware/backlight.nix
        ../../modules/nixos/hardware/networking.nix
        ../../modules/nixos/hardware/sound.nix
        ../../modules/nixos/security/doas.nix
        ../../modules/nixos/services/power-management.nix
        ./hardware-configuration.nix
    ];

    boot.kernelPackages = pkgs.linuxPackages_latest;

    environment.systemPackages = with pkgs; [
        bottom
        bat
        eza
        git
        nvf-config.packages.${pkgs.stdenv.hostPlatform.system}.default
        unzip
    ];

    i18n.defaultLocale = "en_US.UTF-8";

    # for Fragments (BitTorrent client)
    networking.firewall.allowedTCPPorts = [ 51413 ];

    networking.hostName = "segmented-usb";

    services.actkbd.enable = true;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    system.stateVersion = "26.05";
}
