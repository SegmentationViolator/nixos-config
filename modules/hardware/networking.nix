{ ... }:

{

    networking = {
        dhcpcd.enable = false;
        nftables.enable = true;
    };

    networking.nameservers = [
        "1.1.1.1"
        "8.8.8.8"
        "8.8.4.4"
    ];

    networking.networkmanager = {
        enable = true;
        dns = "none";
    };

    networking.useDHCP = false;
}
