{ lib, pkgs, modulesPath, nvf-config, ... }:

{
    imports = [
        (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")

        ../../modules/bootloader/systemd-boot.nix
        ../../modules/hardware/backlight.nix
        ../../modules/hardware/networking.nix
        ../../modules/hardware/sound.nix
        ../../modules/security/doas.nix
        ../../modules/services/power-management.nix
    ];

    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.supportedFilesystems = {
        ntfs = true;
        zfs = lib.mkForce false;
    };

    environment.systemPackages = with pkgs; [
        bottom
        bat
        eza
        fastfetch
        git
        nvf-config.packages.${pkgs.stdenv.hostPlatform.system}.default
        unzip

        ntfs3g
    ];

    i18n.defaultLocale = "en_US.UTF-8";

    networking.hostName = "segmented-usb";

    services.actkbd.enable = true;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    system.stateVersion = "26.05";
}
