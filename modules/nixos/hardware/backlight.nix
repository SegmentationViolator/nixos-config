{ lib, pkgs, ... }:

{
    environment.systemPackages = [ pkgs.brightnessctl ];

    services.actkbd.bindings = [
        { keys = [ 224 ]; events = [ "key" ]; command = "${lib.getExe' pkgs.brightnessctl "brightnessctl"} set 10%-"; }
        { keys = [ 225 ]; events = [ "key" ]; command = "${lib.getExe' pkgs.brightnessctl "brightnessctl"} set 10%+"; }
    ];

}
