{
  config,
  pkgs,
  lib,
  ...
}:

# Rose Pine Moon colors:
# base:     #232136
# surface:  #2a273f
# overlay:  #393552
# muted:    #6e6a86
# subtle:   #908caa
# text:     #e0def4
# love:     #eb6f92
# gold:     #f6c177
# rose:     #ea9a97
# pine:     #3e8fb0
# foam:     #9ccfd8
# iris:     #c4a7e7

{
  dconf.enable = true;

  # Remove GTK titlebars via dconf
  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "";
    };
  };

  # GTK theming to remove CSD decorations
  gtk = {
    enable = true;
    theme.name = "Adwaita-dark";
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-decoration-layout = "";
    };
    gtk4.extraConfig = {
      gtk-decoration-layout = "";
    };
  };

  # Niri configuration
  xdg.configFile."niri/config.kdl".force = true;
  xdg.configFile."niri/config.kdl".text = ''
    // Input configuration
    input {
      keyboard {
        xkb {
          layout "gb"
          variant "mac"
        }
      }

      touchpad {
        tap
        natural-scroll
        accel-speed 0.2
      }

      mouse {
        accel-speed 0.0
      }

      focus-follows-mouse
    }

    // Output/display configuration
    output "eDP-1" {
      scale 1.0
    }

    // Layout configuration
    layout {
      gaps 12
      center-focused-column "never"

      preset-column-widths {
        proportion 0.33333
        proportion 0.5
        proportion 0.66667
      }

      default-column-width { proportion 0.5; }

      focus-ring {
        width 2
        active-color "#c4a7e7"
        inactive-color "#393552"
      }

      border {
        off
      }
    }

    // Spawn at startup
    spawn-at-startup "xwayland-satellite"
    spawn-at-startup "waybar"
    spawn-at-startup "mako"
    spawn-at-startup "swww-daemon"
    spawn-at-startup "variety"
    spawn-at-startup "wl-paste" "--watch" "cliphist" "store"
    spawn-at-startup "swayidle" "-w" "timeout" "300" "swaylock -f" "timeout" "600" "niri msg action power-off-monitors" "resume" "niri msg action power-on-monitors" "before-sleep" "swaylock -f"

    // Cursor
    cursor {
      xcursor-theme "Adwaita"
      xcursor-size 25
    }

    // Prefer server-side decorations
    prefer-no-csd

    // Screenshot path
    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    // Window rules
    window-rule {
      geometry-corner-radius 0
      clip-to-geometry true
    }

    window-rule {
      match app-id=r#"^org\.gnome\."#
      match app-id="nautilus"
      match app-id="pavucontrol"
      match app-id="nm-connection-editor"
      match app-id="blueman-manager"
      match title="Open File"
      match title="Save File"
      match title="Open Folder"

      open-floating true
    }

       // Keybindings
    binds {
      // Mod = Super/Logo key
      Mod+T { spawn "alacritty"; }
      Mod+D { spawn "wofi" "--show" "drun"; }
      Mod+B { spawn "zen"; }
      Ctrl+Shift+W { spawn "bash" "-c" "~/wofi/launcher.sh"; }
      Mod+Q { close-window; }

      // Vim-style navigation
      Mod+H { focus-column-left; }
      Mod+J { focus-workspace-down; }
      Mod+K { focus-workspace-up; }
      Mod+L { focus-column-right; }

      Mod+Shift+H { move-column-left; }
      Mod+Shift+J { move-window-to-workspace-down; }
      Mod+Shift+K { move-window-to-workspace-up; }
      Mod+Shift+L { move-column-right; }

      // Arrow key navigation
      Mod+Left { focus-column-left; }
      Mod+Down { focus-window-down; }
      Mod+Up { focus-window-up; }
      Mod+Right { focus-column-right; }

      Mod+Shift+Left { move-column-left; }
      Mod+Shift+Down { move-window-down; }
      Mod+Shift+Up { move-window-up; }
      Mod+Shift+Right { move-column-right; }

      // Workspaces
      Mod+1 { focus-workspace 1; }
      Mod+2 { focus-workspace 2; }
      Mod+3 { focus-workspace 3; }
      Mod+4 { focus-workspace 4; }
      Mod+5 { focus-workspace 5; }
      Mod+6 { focus-workspace 6; }
      Mod+7 { focus-workspace 7; }
      Mod+8 { focus-workspace 8; }
      Mod+9 { focus-workspace 9; }

      Mod+Shift+1 { move-column-to-workspace 1; }
      Mod+Shift+2 { move-column-to-workspace 2; }
      Mod+Shift+3 { move-column-to-workspace 3; }
      Mod+Shift+4 { move-column-to-workspace 4; }
      Mod+Shift+5 { move-column-to-workspace 5; }
      Mod+Shift+6 { move-column-to-workspace 6; }
      Mod+Shift+7 { move-column-to-workspace 7; }
      Mod+Shift+8 { move-column-to-workspace 8; }
      Mod+Shift+9 { move-column-to-workspace 9; }

      // Window sizing
      Mod+F { maximize-column; }
      Mod+Shift+F { fullscreen-window; }
      Mod+Minus { set-column-width "-10%"; }
      Mod+Apostrophe { set-column-width "+10%"; }

      // Column management (vertical stacking)
      Mod+C { consume-window-into-column; }
      Mod+Shift+C { expel-window-from-column; }

      // Floating
      Mod+Space { toggle-window-floating; }

      // Clipboard
      Mod+V { spawn "bash" "-c" "cliphist list | wofi --dmenu | cliphist decode | wl-copy"; }

      // Lock screen
      Mod+Escape { spawn "swaylock"; }

      // Screenshot
      Print { screenshot; }
      Ctrl+Print { screenshot-screen; }
      Alt+Print { screenshot-window; }

      // Screenshot with satty annotation
      Mod+Print { spawn "bash" "-c" "grim -g \"$(slurp)\" - | satty -f -"; }

      // Media keys
      XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
      XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
      XF86AudioMute { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
      XF86AudioMicMute { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }

      XF86MonBrightnessUp { spawn "brightnessctl" "set" "5%+"; }
      XF86MonBrightnessDown { spawn "brightnessctl" "set" "5%-"; }

      XF86AudioPlay { spawn "playerctl" "play-pause"; }
      XF86AudioNext { spawn "playerctl" "next"; }
      XF86AudioPrev { spawn "playerctl" "previous"; }

      // Overview
      Mod+O { toggle-overview; }

      // Power controls
      Mod+Shift+E { quit; }
    }
  '';

  # Waybar configuration
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 24;
        spacing = 8;

        modules-left = [
          "niri/workspaces"
          "niri/window"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "mpris"
          "pulseaudio"
          "network"
          "battery"
          "tray"
          "custom/power"
        ];

        "niri/workspaces" = {
          format = "{index}";
          on-click = "activate";
        };

        "niri/window" = {
          format = "{}";
          max-length = 50;
        };

        clock = {
          format = "{:%Y-%m-%d %H:%M}";
          format-alt = "{:%H:%M}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = " muted";
          format-icons = {
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "pavucontrol";
        };

        network = {
          format-wifi = " {signalStrength}%";
          format-ethernet = " [x]";
          format-disconnected = " disconnected";
          tooltip-format = "{ifname}: {ipaddr}";
        };

        battery = {
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };

        tray = {
          spacing = 10;
        };

        mpris = {
          format = "{player_icon} {title}";
          format-paused = "{status_icon} {title}";
          player-icons = {
            default = "▶";
            spotify = "";
            firefox = "";
          };
          status-icons = {
            paused = "⏸";
          };
          max-length = 30;
          tooltip-format = "{player}: {title} - {artist}";
        };

        "custom/power" = {
          format = "⏻";
          tooltip = true;
          tooltip-format = "Power Menu";
          on-click = "bash -c ~/.local/bin/power-menu.sh";
        };
      };
    };
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
        color: #e0def4;
      }

      window#waybar > box {
        margin: 4px 12px 0 12px;
        background-color: rgba(35, 33, 54, 0.85);
        border-radius: 0;
        padding: 2px 6px;
      }

      #workspaces {
        background-color: #2a273f;
        border-radius: 0;
        margin: 2px 4px;
        padding: 0 2px;
      }

      #workspaces button {
        padding: 2px 8px;
        margin: 1px;
        color: #6e6a86;
        background: transparent;
        border: none;
        border-radius: 0;
        transition: all 0.2s ease;
      }

      #workspaces button.active {
        color: #c4a7e7;
        background-color: #393552;
        border-bottom: 2px solid #c4a7e7;
      }

      #workspaces button:hover {
        color: #e0def4;
        background-color: #393552;
      }

      #window {
        color: #908caa;
        padding: 2px 10px;
        margin: 2px 4px;
      }

      #clock {
        color: #e0def4;
        font-weight: bold;
        background-color: #2a273f;
        border-radius: 0;
        padding: 2px 12px;
        margin: 2px 4px;
      }

      #pulseaudio,
      #network,
      #battery,
      #tray {
        background-color: #2a273f;
        border-radius: 0;
        padding: 2px 10px;
        margin: 2px 4px;
        transition: all 0.2s ease;
      }

      #pulseaudio {
        color: #9ccfd8;
      }

      #pulseaudio:hover {
        background-color: #393552;
      }

      #pulseaudio.muted {
        color: #6e6a86;
      }

      #network {
        color: #3e8fb0;
      }

      #network:hover {
        background-color: #393552;
      }

      #network.disconnected {
        color: #eb6f92;
      }

      #battery {
        color: #f6c177;
      }

      #battery:hover {
        background-color: #393552;
      }

      #battery.charging {
        color: #9ccfd8;
      }

      #battery.warning:not(.charging) {
        color: #ea9a97;
      }

      #battery.critical:not(.charging) {
        color: #eb6f92;
      }

      #tray {
        color: #e0def4;
      }

      #tray:hover {
        background-color: #393552;
      }

      #mpris {
        background-color: #2a273f;
        border-radius: 0;
        padding: 2px 10px;
        margin: 2px 4px;
        color: #c4a7e7;
      }

      #mpris:hover {
        background-color: #393552;
      }

      #mpris.paused {
        color: #6e6a86;
      }

      #custom-power {
        background-color: #2a273f;
        border-radius: 0;
        padding: 2px 10px;
        margin: 2px 4px;
        color: #eb6f92;
      }

      #custom-power:hover {
        background-color: #393552;
      }

      tooltip {
        background-color: #232136;
        border: 2px solid #c4a7e7;
        border-radius: 0;
      }

      tooltip label {
        color: #e0def4;
        padding: 4px;
      }
    '';
  };

  # Gammastep for night light
  services.gammastep = {
    enable = true;
    dawnTime = "08:00";
    duskTime = "20:00";
    temperature = {
      day = 6500;
      night = 2500;
    };
    tray = true;
  };

  # Mako notification daemon
  services.mako = {
    enable = true;
    backgroundColor = "#232136";
    textColor = "#e0def4";
    borderColor = "#c4a7e7";
    borderRadius = 0;
    borderSize = 2;
    defaultTimeout = 5000;
    font = "JetBrainsMono Nerd Font 11";
    width = 350;
    height = 150;
    margin = "12";
    padding = "12";
    anchor = "top-right";
    layer = "overlay";
  };

  # Swaylock configuration
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      color = "232136";
      bs-hl-color = "eb6f92";
      caps-lock-bs-hl-color = "eb6f92";
      caps-lock-key-hl-color = "9ccfd8";
      inside-color = "00000000";
      inside-clear-color = "00000000";
      inside-caps-lock-color = "00000000";
      inside-ver-color = "00000000";
      inside-wrong-color = "00000000";
      key-hl-color = "c4a7e7";
      layout-bg-color = "00000000";
      layout-border-color = "00000000";
      layout-text-color = "e0def4";
      line-color = "00000000";
      line-clear-color = "00000000";
      line-caps-lock-color = "00000000";
      line-ver-color = "00000000";
      line-wrong-color = "00000000";
      ring-color = "393552";
      ring-clear-color = "9ccfd8";
      ring-caps-lock-color = "f6c177";
      ring-ver-color = "c4a7e7";
      ring-wrong-color = "eb6f92";
      separator-color = "00000000";
      text-color = "e0def4";
      text-clear-color = "9ccfd8";
      text-caps-lock-color = "f6c177";
      text-ver-color = "c4a7e7";
      text-wrong-color = "eb6f92";

      effect-blur = "8x5";
      fade-in = 0.2;
      font = "JetBrainsMono Nerd Font";
      font-size = 24;
      indicator = true;
      indicator-radius = 100;
      indicator-thickness = 7;
      screenshots = true;
    };
  };

  # Create Screenshots directory
  home.file."Pictures/Screenshots/.keep".text = "";

  # Power menu script for wofi
  home.file.".local/bin/power-menu.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      entries=" Lock\n Logout\n⏾ Suspend\n Reboot\n⏻ Shutdown"
      selected=$(echo -e "$entries" | wofi --dmenu --prompt "Power Menu" --cache-file /dev/null | sed 's/^[^ ]* //')

      case $selected in
        Lock)
          swaylock
          ;;
        Logout)
          niri msg action quit
          ;;
        Suspend)
          systemctl suspend
          ;;
        Reboot)
          systemctl reboot
          ;;
        Shutdown)
          systemctl poweroff
          ;;
      esac
    '';
  };

  # Variety wallpaper setter script for swww
  home.file.".config/variety/scripts/set_wallpaper" = {
    force = true;
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Variety calls this script with the wallpaper path as $1
      swww img "$1" --transition-type wipe --transition-duration 2
    '';
  };

  # Wofi config
  xdg.configFile."wofi/config".text = ''
    width=500
    height=300
    location=center
    show=drun
    prompt=
    filter_rate=100
    allow_markup=true
    no_actions=true
    halign=fill
    orientation=vertical
    content_halign=fill
    insensitive=true
    allow_images=true
    image_size=24
    gtk_dark=true
    layer=overlay
    matching=fuzzy
  '';

  xdg.configFile."wofi/style.css".text = ''
    window {
      margin: 0;
      background-color: #232136;
      border: 2px solid #c4a7e7;
      color: #e0def4;
      font-family: "JetBrainsMono Nerd Font", monospace;
      font-size: 14px;
    }

    #input {
      margin: 8px;
      border: none;
      border-bottom: 2px solid #c4a7e7;
      color: #e0def4;
      background-color: #2a273f;
      padding: 8px;
    }

    #inner-box {
      margin: 4px 8px;
      border: none;
      background-color: transparent;
    }

    #outer-box {
      margin: 0;
      border: none;
      background-color: transparent;
    }

    #scroll {
      margin: 0;
      border: none;
    }

    #text {
      margin: 4px;
      border: none;
      color: #e0def4;
    }

    #entry {
      padding: 4px;
    }

    #entry:selected {
      background-color: #c4a7e7;
      color: #232136;
    }

    #entry:selected #text {
      color: #232136;
    }

    #img {
      margin-right: 8px;
    }
  '';

  # Force overwrite existing config files
  xdg.configFile."waybar/config".force = true;
  xdg.configFile."waybar/style.css".force = true;
  xdg.configFile."mako/config".force = true;
  xdg.configFile."wofi/config".force = true;
  xdg.configFile."wofi/style.css".force = true;

}
