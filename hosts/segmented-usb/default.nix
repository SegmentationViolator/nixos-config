{ pkgs, nvf-config, ... }:

{
    imports = [
        ../../modules/bootloader/systemd-boot.nix
        ../../modules/hardware/backlight.nix
        ../../modules/hardware/networking.nix
        ../../modules/hardware/sound.nix
        ../../modules/security/doas.nix
        ../../modules/services/power-management.nix
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

    networking.hostName = "segmented-usb";

    services.actkbd.enable = true;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    system.stateVersion = "26.05";
}
