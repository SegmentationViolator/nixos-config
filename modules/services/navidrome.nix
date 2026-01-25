{ ... }:

{
    services.navidrome = {
        enable = true;
        openFirewall = false;

        settings = {
            MusicFolder = "/mnt/media/Music";
        };
    };
}
