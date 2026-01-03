{ ... }:

{
    programs.vesktop = {
        enable  = true;

        vencord.settings = {
            autoUpdate = false;
            autoUpdateNotification = false;
            notifyAboutUpdates = false;
        };

        vencord.useSystem = true;
    };
}
