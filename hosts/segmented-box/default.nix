{ pkgs, ... }:

{
    imports = [
        ../../modules/bootloader/systemd-boot.nix

        ../../modules/hardware/backlight.nix
        ../../modules/hardware/bluetooth.nix
        ../../modules/hardware/networking.nix
        ../../modules/hardware/nvidia.nix
        ../../modules/hardware/sound.nix

        ../../modules/nixpkgs/unfree.nix

        ../../modules/programs/doas.nix

        ../../modules/services/navidrome.nix
        ../../modules/services/power-management.nix

        ../../users/ale

        ./hardware-configuration.nix
    ];

    boot.kernelPackages = pkgs.linuxPackages_latest;

    boot.binfmt.emulatedSystems = [
        "aarch64-linux"
        "riscv64-linux"
    ];

    documentation.nixos.enable = false;

    environment.systemPackages = with pkgs; [
        bat
        eza
    ];

    i18n.defaultLocale = "en_US.UTF-8";

    networking.hostName = "segmented-box";

    programs.git.enable = true;
    programs.gnupg.agent.enable = true;

    services.actkbd.enable = true;

    time.timeZone = "Asia/Kolkata";

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    nix.settings.extra-platforms = [
        "aarch64-linux"
        "riscv64-linux"
    ];

    system.stateVersion = "26.05";
}
