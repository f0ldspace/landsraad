{
  config,
  pkgs,
  lib,
  username,
  ...
}:

{
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    name = "catppuccin-mocha-mauve-cursors";
    package = pkgs.catppuccin-cursors.mochaMauve;
    size = 24;
  };

  dconf.enable = true;

  # Remove GTK titlebars via dconf
  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "";
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  # GTK theming to remove CSD decorations
  gtk = {
    enable = true;
    gtk3.extraConfig = { gtk-decoration-layout = ""; };
    gtk4 = { theme = null; extraConfig = { gtk-decoration-layout = ""; }; };
  };

  # Alacritty configuration
  programs.alacritty = {
    enable = true;
    settings = {
      general.import = [
        "~/.config/alacritty/dank-theme.toml"
      ];

      font = {
        size = 12.0;
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Italic";
        };
      };

      window = {
        padding = {
          x = 8;
          y = 8;
        };
        opacity = 0.95;
      };

    };
  };

  # Niri configuration
  xdg.configFile."niri/config.kdl".force = true;
  xdg.configFile."niri/config.kdl".text = ''
    // DMS theme includes
    include "dms/colors.kdl"
    include "dms/layout.kdl"
    include "dms/outputs.kdl"
    include "dms/wpblur.kdl"
    include "dms/alttab.kdl"

    // Input configuration
    input {
      keyboard {
        xkb {
          layout "gb"
          variant ""
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

      // focus-follows-mouse
    }

    // Output/display configuration provided by DMS via dms/outputs.kdl

    // Layout configuration
    layout {
      default-column-display "tabbed"

      gaps 12
      center-focused-column "on-overflow"

      preset-column-widths {
        proportion 0.5
        proportion 1.0
      }

      default-column-width { proportion 0.5; }

      shadow {
        on
      }

      // focus-ring and border colors provided by DMS
    }

    // Spawn at startup
    spawn-at-startup "xwayland-satellite"
    spawn-at-startup "wl-paste" "--watch" "cliphist" "store"
    spawn-at-startup "nm-applet" "--indicator"

    // Cursor
    cursor {
      xcursor-theme "catppuccin-mocha-mauve-cursors"
      xcursor-size 24
    }

    // Prefer server-side decorations
    prefer-no-csd

    // Screenshot path
    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    // Window rules
    window-rule {
      geometry-corner-radius 8
      clip-to-geometry true
    }

    window-rule {
      match app-id=r#"^org\.gnome\."#
      match app-id="nautilus"
      match app-id="nm-connection-editor"
      match app-id="blueman-manager"
      match title="Open File"
      match title="Save File"
      match title="Open Folder"

      open-floating true
    }
    window-rule {
      match app-id="yazi"
      open-floating true
    }

    window-rule {
      match title="Huddle:"
      default-column-width { proportion 0.2; }
    }
    window-rule {
      match app-id="org.pwmt.zathura"
      default-column-width { proportion 0.4; }
    }

    window-rule {
      match title="OpenSpeedRun"
      default-column-width { proportion 0.2; }
    }


       // Keybindings
    binds {
      // Mod = Super/Logo key
      Mod+Return { spawn "alacritty"; }
      Mod+N { spawn "dms" "ipc" "call" "notifications" "toggleDoNotDisturb"; }
      Mod+D { spawn "dms" "ipc" "call" "spotlight" "toggle"; }
      Mod+B { spawn "zen"; }
      Ctrl+Shift+W { spawn "bash" "-c" "~/wofi/launcher.sh"; }
      Mod+Q { close-window; }
      Mod+Shift+W { spawn "alacritty" "--working-directory" "/home/${username}/.local/share/Cryptomator/mnt/wall/wall/" "-e" "opencode" "--agent" "wiki"; }
      Mod+W { spawn "obsidian"; }
      Mod+R { switch-preset-column-width; }

      // Vim-style navigation
      Mod+H { focus-column-left; }
      Mod+Tab { focus-workspace-down; }
      Mod+Shift+Tab { focus-workspace-up; }
      Mod+L { focus-column-right; }

      Mod+Shift+H { move-column-left; }
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

      // Speedrunning
      Mod+Y { spawn "bash" "-c" "if niri msg windows | grep -qF 'Title: \"OpenSpeedRun\"'; then openspeedrun-cli split; else alacritty --class yazi -e yazi; fi"; }
      Mod+U { spawn "openspeedrun-cli" "reset"; }
      Mod+I { spawn "openspeedrun-cli" "pause"; }

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
      Mod+Plus { set-column-width "+10%"; }

      // Column management (vertical stacking)
      Mod+C { consume-window-into-column; }
      Mod+Shift+C { expel-window-from-column; }

      // Floating
      Mod+Space { toggle-window-floating; }

      // Clipboard (DMS)
      Mod+V { spawn "dms" "ipc" "call" "clipboard" "toggle"; }

      // Lock screen (DMS)
      Mod+Escape { spawn "dms" "ipc" "call" "lock" "lock"; }

      // Screenshot
      Mod+P { screenshot; }
      Ctrl+Print { spawn "dms" "ipc" "call" "niri" "screenshotScreen"; }
      Alt+Print { spawn "dms" "ipc" "call" "niri" "screenshotWindow"; }

      // Screenshot with satty annotation
      Mod+Shift+P { spawn "bash" "-c" "grim -g \"$(slurp)\" - | satty -f -"; }

      // Media keys (DMS)
      XF86AudioRaiseVolume { spawn "dms" "ipc" "call" "audio" "increment" "5"; }
      XF86AudioLowerVolume { spawn "dms" "ipc" "call" "audio" "decrement" "5"; }
      XF86AudioMute { spawn "dms" "ipc" "call" "audio" "mute"; }
      XF86AudioMicMute { spawn "dms" "ipc" "call" "audio" "micmute"; }

      XF86MonBrightnessUp { spawn "dms" "ipc" "call" "brightness" "increment" "5"; }
      XF86MonBrightnessDown { spawn "dms" "ipc" "call" "brightness" "decrement" "5"; }

      XF86AudioPlay { spawn "dms" "ipc" "call" "mpris" "playPause"; }
      XF86AudioNext { spawn "dms" "ipc" "call" "mpris" "next"; }
      XF86AudioPrev { spawn "dms" "ipc" "call" "mpris" "previous"; }

      // DMS panels
      Mod+A { spawn "dms" "ipc" "call" "control-center" "toggle"; }
      Mod+Shift+N { spawn "dms" "ipc" "call" "notifications" "toggle"; }
      Mod+Shift+S { spawn "dms" "ipc" "call" "settings" "toggle"; }

      // Overview
      Mod+O { toggle-overview; }

      // Power controls
      Mod+Shift+E { quit; }
    }
  '';

  # Waybar configuration (disabled)
  programs.waybar = {
    enable = false;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 24;
        spacing = 1;

        modules-left = [
          "niri/workspaces"
          "mpris"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "pulseaudio"
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
          format = "{:%H:%M}";
          format-alt = "{:%H:%M, %a, %d-%m-%y}";
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
          on-click = "alacritty -e pulsemixer";
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
  # Mako notification daemon (disabled)
  services.mako = {
    enable = false;
    settings = {
      border-radius = 0;
      border-size = 2;
      default-timeout = 5000;
      font = "JetBrainsMono Nerd Font 11";
      width = 350;
      height = 150;
      margin = "12";
      padding = "12";
      anchor = "top-right";
      layer = "overlay";

      "mode=do-not-disturb" = {
        invisible = 1;
      };
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
          dms ipc call lock lock
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
  xdg.configFile."wofi/config".force = true;
  xdg.configFile."wofi/style.css".force = true;

  # Yazi file manager with Rose Pine Moon
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = {
      manager = {
        show_hidden = true;
        sort_by = "natural";
        sort_dir_first = true;
        linemode = "size";
      };
    };
  };

}
