{ ... }:

{
    networking.dhcpcd.enable = false;

    networking.nameservers = [
        "1.1.1.1"
        "1.0.0.1"
        "8.8.8.8"
        "8.8.4.4"
    ];

    networking.networkmanager = {
        enable = true;
        dns = "none";
    };

    networking.useDHCP = false;
}
