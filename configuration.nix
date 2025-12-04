{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./nvf/configuration.nix
    ./modules/exceptions.nix
    ./modules/package-overrides.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "segmentedbox";
  networking.networkmanager.enable = true;

  fonts.packages = with pkgs; [
    font-awesome
    monaspace
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  time.timeZone = "Asia/Kolkata";

  i18n.defaultLocale = "en_US.UTF-8";

  hardware.graphics.enable = true;

  hardware.nvidia = {
    open = true;

    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";

      offload = {
        enable = true;
        enableOffloadCmd = true;      
      };
    };
  };

  services.xserver.videoDrivers = [ "modesetting" "nvidia" ];

  services.libinput.enable = true;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.printing.enable = true;

  users.defaultUserShell = pkgs.zsh;

  users.users.ale = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  security.sudo.enable = false;

  security.doas.enable = true;

  environment.systemPackages = with pkgs; [
    bottom
    bat
    eza
    fastfetch
    git
    neovim
    unzip
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.niri.enable = true;

  programs.zsh.enable = true;

  system.stateVersion = "25.05";

  nix.gc.automatic = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
