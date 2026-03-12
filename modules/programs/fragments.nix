{ pkgs, ... }:

{
    networking.firewall.allowedTCPPortRanges = [
        {
            from = 49152;
            to = 65534;
        }
    ];


    environment.systemPackages = [ pkgs.fragments ];
}
