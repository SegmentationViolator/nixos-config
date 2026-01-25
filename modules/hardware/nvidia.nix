{ lib, ... }:

{
    hardware.graphics.enable = true;

    hardware.nvidia = {
        open = true;
        modesetting.enable = true;

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

    unfreePackages = [
        "nvidia-settings"
        "nvidia-x11"
    ];

    specialisation.no-nvidia.configuration = {
        services.xserver.videoDrivers = lib.mkForce [ "modesetting" ];
    };
}
