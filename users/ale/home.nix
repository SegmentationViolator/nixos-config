{ lib, pkgs, ... }:

let
  wallpaper = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/5y/wallhaven-5yd6d5.png";
    hash = "sha256-KJV1PUMofXWlX/R8qUuIuhQTBnQ7QXXioWghkZQ/5Hk=";
  };
  backdrop = pkgs.runCommand "backdrop.png" { buildInputs = [ pkgs.imagemagick ]; } ''
    ${lib.getExe' pkgs.imagemagick "magick"} ${wallpaper} -blur 0x8 -fill black -colorize 40% $out
  '';
  matugenGenerations = pkgs.runCommand "matugen-generations" {
    buildInputs = [ pkgs.matugen ];
    src = ./matugen;
    inherit wallpaper;
  } ''
    mkdir -p $out
    cp -r $src ./matugen
    mkdir ./generated
    ${lib.getExe' pkgs.matugen "matugen"} image -c ./matugen/config.toml --json strip $wallpaper > $out/colors.json
    install -Dm444 ./generated/* $out
  '';
  colors = (builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile (matugenGenerations + "/colors.json")))).colors;
in
{
  home.pointerCursor =
    let 
      getFrom = url: hash: name: {
        gtk.enable = false;
        x11.enable = false;
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
    fuzzel
    papirus-icon-theme
    nautilus
    stremio-service
    swaybg
  ];

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.floorp = {
    enable = true;
    policies = {
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          default_area = "menupanel";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "normal_installed";
          private_browsing = true;
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          default_area = "menupanel";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "normal_installed";
          private_browsing = false;            
        };
        "support@premid.app" = {
          default_area = "menupanel";
          install_url = "https://dl.premid.app/PreMiD.xpi";
          installation_mode = "normal_installed";
          private_browsing = false;
        };
      };
      GenerativeAI = {
        Enabled = false;
      };
    };
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        icon-theme = "Papirus-Dark";
        terminal = "${lib.getExe' pkgs.ghostty "ghostty"} -e {cmd}";
      };
        colors = {
          background = "${colors.background.default}ff";
          text = "${colors.on_surface.default}ff";
          prompt = "${colors.secondary.default}ff";
          placeholder = "${colors.tertiary.default}ff";
          input = "${colors.primary.default}ff";
          match = "${colors.tertiary.default}ff";
          selection = "${colors.primary.default}ff";
          selection-text = "${colors.on_surface.default}ff";
          selection-match = "${colors.on_primary.default}ff";
          counter = "${colors.secondary.default}ff";
          border = "${colors.primary.default}ff";
        };
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      prompt = "enabled";
      color_labels = "enabled";
      spinner = "enabled";
    };
  };

  programs.ghostty = {
    enable = true;
    settings = {
      background-opacity = 0.8;
      font-family = "Monaspace Neon";
      font-feature = "+calt, +ss01, +ss02, +ss03, +ss04, +ss05, +ss06, +ss07, +ss08, +ss09, +liga";
      quit-after-last-window-closed = true;
      quit-after-last-window-closed-delay = "5m";
      theme = "TokyoNight";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user.name  = "SegmentationViolator";
      user.email = "segmentationviolator@proton.me";
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
      pride_month_disable = true;
    };
  };

  programs.nix-your-shell.enable = true;

  programs.vesktop = {
    enable = true;
    vencord.settings = {
      autoUpdate = false;
      autoUpdateNotification = false;
      notifyAboutUpdates = false;
    };
    vencord.useSystem = true;
  };

  programs.waybar = {
    enable = true;
    settings = [{
      height = 32;
      layer = "top";
      margin-left = 4;
      margin-right = 4;
      margin-top = 4;
      modules-center = [ "clock" ];
      modules-left = [ "wlr/taskbar" ];
      modules-right = [ "tray" "network" "wireplumber" "battery" ];
      spacing = 0;

      battery = {
        format = "{icon}";
        format-charging = "&#xe55b;";
        format-plugged = "&#xf1e6;";
        format-icons = [ "&#xf243;" "&#xf242;" "&#xf241;" "&#xf240;" ];            
      };

      clock = {
         format = "{:%e %B %R}";
         tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };

      network = {
        format-disconnected = "&#xf071;";
        format-ethernet = "&#xf796;";
        format-linked = "&#xf796;";
        format-wifi = "&#xf1eb;";
        tooltip-format = "{essid}";
        tooltip-format-disconnected = "Not Connected";
        tooltip-format-ethernet =  "Ethernet";
        tooltip-format-linked = "USB Ethernet";
      };

      tray = { spacing = 10; };

      wireplumber = {
        format = "{icon}";
        format-icons = builtins.genList (i: if i == 0 then "&#xf026;" else if i <= 50 then "&#xf027;" else "&#xf028;") 100;
        format-muted = "&#xf6a9;";
        tooltip-format = "{volume}%";
      };

      "wlr/taskbar" = {
        format = "{icon}";
        icon-theme = "Papirus-Dark";
        on-click = "activate";
        tooltip-format = "{title}";
      };
    }];
    style = ./waybar.css;
    systemd.enable = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history.ignoreAllDups = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "gh"
      ];
      theme = "lambda";
    };
  };

  services.mako = {
    enable = true;
    settings = {
        background-color = "#${colors.on_primary.default}";
        border-color = "#${colors.tertiary_container.default}";
        default-timeout = 5000;
        icon-path = "#${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";
        text-color = "#${colors.tertiary.default}";

      "mode=do-not-disturb" = {
        invisible=1;
        on-notify = "none";
      };

      "mode=silent" = {
        on-notify = "none";
      };

        "urgency=high" = {
          border-color = "#${colors.error_container.default}";
        };
    };
  };

  services.polkit-gnome.enable = true;

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

  xdg.configFile."niri/config.kdl".source = matugenGenerations + "/niri.kdl";

  home.stateVersion = "25.05";
}
