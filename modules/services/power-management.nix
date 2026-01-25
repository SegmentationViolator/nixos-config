{ ... }:

{
    services.logind.settings.Login = {
        HandleLidSwitch = "suspend";
        HandleLidSwitchExternalPower = "lock";
        HandleLidSwitchDocked = "ignore";
    };

    services.thermald.enable = true;

    services.tlp.enable = true;
}
