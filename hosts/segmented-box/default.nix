{ pkgs, ... }:

{
    imports = [
        ../../modules/bootloader/systemd-boot.nix
        ../../modules/hardware/backlight.nix
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

    environment.systemPackages = with pkgs; [
        bottom
        bat
        eza
        git
        unzip
    ];

    i18n.defaultLocale = "en_US.UTF-8";

    networking.hostName = "segmented-box";

    programs.gnupg.agent.enable = true;

    services.actkbd.enable = true;

    time.timeZone = "Asia/Kolkata";

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    system.stateVersion = "26.05";
}
