{lib, ...}:

{
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-settings"
      "nvidia-x11"
      "stremio-server"
      "stremio-service"
    ];
}
