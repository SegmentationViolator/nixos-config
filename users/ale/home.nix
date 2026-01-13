{ config, lib, pkgs, matugen, nix-index-database, ... }:

let

    backdrop = pkgs.runCommand "backdrop.png" { buildInputs = [ pkgs.imagemagick ]; } ''
        ${lib.getExe' pkgs.imagemagick "magick"} ${wallpaper} -blur 0x8 -fill black -colorize 40% $out
    '';

    wallpaper = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/1q/wallhaven-1q83qg.jpg";
        hash = "sha256-QPmG4QTRvubuX6Fy5rmMwYKw4aQdBiH/zGL/PMmUZOk=";
    };
in
{
    imports = [
        matugen.nixosModules.default
        nix-index-database.homeModules.default
        ../../modules/home/programs/direnv.nix
        ../../modules/home/programs/gh.nix
        ../../modules/home/programs/ghostty.nix
        ../../modules/home/programs/matugen
        ../../modules/home/programs/vesktop.nix
        ../../modules/home/programs/waybar.nix
        ../../modules/home/programs/zsh.nix
        ../../modules/home/services/mako.nix
    ];

    fonts.fontconfig.enable = true;

    gtk = {
        enable = true;
        colorScheme = "dark";
        gtk4.theme = config.gtk.theme;

        iconTheme = {
            name = "Papirus";
            package = pkgs.papirus-icon-theme.override {
                color = "violet";
            };
        };

        theme = {
            name = "Arc";
            package = pkgs.arc-theme;
        };
    };

    home.pointerCursor =
        let
            getFrom = url: hash: name: {
                enable = true;
                dotIcons.enable = false;
                gtk.enable = true;

                name = name;
                size = 24;
                package =
                pkgs.runCommand name {} ''
                    mkdir -p $out/share/icons
                    ln -s ${pkgs.fetchzip {
                        url = url;
                        hash = hash;
                    }} $out/share/icons/${name}
                '';
            };
        in
            getFrom
                "https://github.com/SegmentationViolator/kafka-cursors/releases/download/v1.0/Kafka.tar.gz"
                "sha256-9EKH8A66VrF20S9uSp9+e/qUfXOmBQF6GyycMFaWgiI="
                "Kafka";

    home.packages = with pkgs; [
        bottom
        fastfetch
        feishin
        fragments
        mpv
        nautilus
        nur.repos.forkprince.helium-nightly
        stremio-service
        swaybg

        font-awesome
        monaspace
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
    ];

    programs.fuzzel = {
        enable = true;

        settings = {
            main = {
                icon-theme = "Papirus";
                terminal = "${lib.getExe' pkgs.ghostty "ghostty"} -e {cmd}";
            };

            colors = {
                background = "${config.programs.matugen.theme.colors.background.default}ff";
                text = "${config.programs.matugen.theme.colors.on_surface.default}ff";
                prompt = "${config.programs.matugen.theme.colors.secondary.default}ff";
                placeholder = "${config.programs.matugen.theme.colors.tertiary.default}ff";
                input = "${config.programs.matugen.theme.colors.primary.default}ff";
                match = "${config.programs.matugen.theme.colors.tertiary.default}ff";
                selection = "${config.programs.matugen.theme.colors.primary.default}ff";
                selection-text = "${config.programs.matugen.theme.colors.on_surface.default}ff";
                selection-match = "${config.programs.matugen.theme.colors.on_primary.default}ff";
                counter = "${config.programs.matugen.theme.colors.secondary.default}ff";
                border = "${config.programs.matugen.theme.colors.primary.default}ff";
            };
        };
    };

    programs.ghostty.font-family = "Monaspace Neon";

    programs.git = {
        enable = true;

        settings = {
            init.defaultBranch = "main";
            user = {
                name = "SegmentationViolator";
                email = "segmentationviolator@proton.me";
            };
        };
    };

    programs.hyfetch = {
        enable = true;

        settings = {
            preset = "transbian";
            mode = "rgb";
            light_dark = "dark";
            lightness = 0.65;
            backend = "fastfetch";
            color_align = { mode = "horizontal"; };
            pride_month_disable = false;
        };
    };

    programs.matugen.wallpaper = wallpaper;

    programs.neovide = {
        enable = true;

        settings = {
            font = {
                size = 12;
                normal = [ "Monaspace Argon" ];
                bold = [ "Monaspace Krypton" ];
                italic = [ "Monaspace Radon" ];

                features = {
                    "Monaspace Argon" = [ "+calt" "+ss01" "+ss02" "+ss03" "+ss04" "+ss05" "+ss06" "+ss07" "+ss08" "+ss09" "+ss10" "+liga" ];
                    "Monaspace Krypton" = [ "+calt" "+ss01" "+ss02" "+ss03" "+ss04" "+ss05" "+ss06" "+ss07" "+ss08" "+ss09" "+ss10" "+liga" ];
                    "Monaspace Radon" = [ "+calt" "+ss01" "+ss02" "+ss03" "+ss04" "+ss05" "+ss06" "+ss07" "+ss08" "+ss09" "+ss10" "+liga" ];
                };
            };
            fork = true;
        };
    };

    programs.nix-index.enable = true;

    programs.waybar.style = builtins.readFile (config.programs.matugen.theme.files + "/waybar.css");

    services.mako.settings = {
        background-color = "#${config.programs.matugen.theme.colors.on_primary.default}";
        border-color = "#${config.programs.matugen.theme.colors.tertiary_container.default}";
        icon-path = "${pkgs.papirus-icon-theme}/share/icons/Papirus";
        text-color = "#${config.programs.matugen.theme.colors.tertiary.default}";

        "urgency=high" = {
            border-color = "#${config.programs.matugen.theme.colors.error_container.default}";
        };
    };

    services.swww = {
        enable = true;
        extraArgs = [ "--no-cache" ];
    };

    systemd.user.services.set-wallpaper = {
        Install = {
            WantedBy = [ "graphical-session.target" ];
        };

        Unit = {
            ConditionEnvironment = "WAYLAND_DISPLAY";
            Description = "Set Wallpaper Using swww";
            After = [ "graphical-session.target" ];
            PartOf = [ "graphical-session.target" ];
        };

        Service = {
            ExecStart = "${lib.getExe' pkgs.swww "swww"} img --resize stretch --transition-type center ${wallpaper}";
            Restart = "on-failure";
        };
    };

    systemd.user.services.set-backdrop = {
        Install = {
            WantedBy = [ "graphical-session.target" ];
        };

        Unit = {
            ConditionEnvironment = "WAYLAND_DISPLAY";
            Description = "Set Backdrop Using swaybg";
            After = [ "graphical-session.target" ];
            PartOf = [ "graphical-session.target" ];
        };

        Service = {
            ExecStart = "${lib.getExe' pkgs.swaybg "swaybg"} -m stretch -i ${backdrop}";
            Restart = "on-failure";
        };
    };

    xdg.desktopEntries = {
        bottom = {
            name = "bottom";
            noDisplay = true;
        };

        nixos-manual = {
            name = "NixOS Manual";
            noDisplay = true;
        };
    };

    xdg.configFile."autostart/com.stremio.service.desktop" = {
        force = true;
        text = "";
    };

    xdg.configFile."niri/config.kdl".source = config.programs.matugen.theme.files + "/niri.kdl";

    home.stateVersion = "26.05";
}
