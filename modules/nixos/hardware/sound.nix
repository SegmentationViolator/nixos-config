{ lib, pkgs, ... }:

{
    security.rtkit.enable = true;

    services.actkbd.bindings = [
        { keys = [ 113 ]; events = [ "key" ]; command = "${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
        { keys = [ 114 ]; events = [ "key" ]; command = "${lib.getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 10%- -l 1.0"; }
        { keys = [ 115 ]; events = [ "key" ]; command = "${lib.getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 10%+ -l 1.0"; }
        { keys = [ 248 ]; events = [ "key" ]; command = "${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }
    ];

    services.pipewire = {
        enable = true;

        alsa = {
            enable = true;
            support32Bit = true;
        };

        pulse.enable = true;
    };
}
