{ lib, pkgs, ... }:

{
    imports = [
        ../../modules/bootloader/systemd-boot.nix
        ../../modules/hardware/backlight.nix
        ../../modules/hardware/bluetooth.nix
        ../../modules/hardware/networking.nix
        ../../modules/hardware/nvidia.nix
        ../../modules/hardware/sound.nix
        ../../modules/nixpkgs/unfree.nix
        ../../modules/security/doas.nix
        ../../modules/services/navidrome.nix
        ../../modules/services/power-management.nix

        ../../users/ale

        ./hardware-configuration.nix
    ];

    boot.kernelPackages = pkgs.linuxPackages_latest;

    boot.binfmt.emulatedSystems = [
        "aarch64-linux"
    ];

    environment.systemPackages = with pkgs; [
        bottom
        bat
        eza
        fastfetch
        unzip
    ];

    i18n.defaultLocale = "en_US.UTF-8";

    networking.hostName = "segmented-box";

    programs.git.enable = true;
    programs.gnupg.agent.enable = true;

    services.actkbd.enable = true;

    time.timeZone = "Asia/Kolkata";

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    nix.settings.extra-platforms = [ "aarch64-linux" ];

    system.stateVersion = "26.05";
}
