{ ... }:

{
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    programs.niri.enable = true;

    security.polkit.enable = true;

    services.gnome.gnome-keyring.enable = true;
}
