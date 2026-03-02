{
  config,
  pkgs,
  lib,
  username,
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
  home.pointerCursor = {
    gtk.enable = true;
    name = "BreezeX-RosePine-Linux";
    package = pkgs.rose-pine-cursor;
    size = 24;
  };

  dconf.enable = true;

  # Remove GTK titlebars via dconf
  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "";
    };
    "org/gnome/desktop/interface" = {
      cursor-theme = "BreezeX-RosePine-Linux";
      cursor-size = 24;
      gtk-theme = "rose-pine-moon";
      icon-theme = "rose-pine-moon";
      color-scheme = "prefer-dark";
    };
  };

  # GTK theming to remove CSD decorations
  gtk = {
    enable = true;
    theme = {
      name = "rose-pine-moon";
      package = pkgs.rose-pine-gtk-theme;
    };
    iconTheme = {
      name = "rose-pine-moon";
      package = pkgs.rose-pine-icon-theme;
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

      // focus-follows-mouse
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
    spawn-at-startup "wl-paste" "--watch" "cliphist" "store"
    spawn-at-startup "swayidle" "-w" "timeout" "1800" "swaylock -f" "timeout" "2700" "niri msg action power-off-monitors" "resume" "niri msg action power-on-monitors" "before-sleep" "swaylock -f"
    spawn-at-startup "nm-applet" "--indicator"

    // Cursor
    cursor {
      xcursor-theme "BreezeX-RosePine-Linux"
      xcursor-size 24
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
    window-rule {
      match app-id="yazi"
      open-floating true
    }
    window-rule {
      match app-id="rmpc"
      open-floating true
    }
    window-rule {
      match title="Taskwarrior"
      open-floating true
    }

    window-rule {
      match app-id="Slack"
      default-column-width { proportion 0.4; }
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

    window-rule {
      match app-id="wiki-nvim"
      default-column-width { proportion 0.3; }
    }


       // Keybindings
    binds {
      // Mod = Super/Logo key
      Mod+T { spawn "alacritty"; }
      Mod+Shift+T { spawn "bash" "-c" "alacritty --title Taskwarrior -e taskwarrior-tui && task synchronize"; }
      Mod+N { spawn "makoctl" "mode" "-t" "do-not-disturb"; }
      Mod+D { spawn "wofi" "--show" "drun"; }
      Mod+B { spawn "zen"; }
      Ctrl+Shift+W { spawn "bash" "-c" "~/wofi/launcher.sh"; }
      Mod+Shift+B { spawn "alacritty" "--class" "blog-todo" "--working-directory" "/home/${username}/blog/todo/" "-e" "trinity"; }
      Mod+S { spawn "flatpak" "run" "net.mkiol.SpeechNote"; }
      Mod+Q { close-window; }
      Mod+Shift+W { spawn "alacritty" "--working-directory" "/home/${username}/wiki/" "-e" "opencode" "--agent" "wiki"; }
      Mod+W { spawn "alacritty" "--class" "wiki-nvim" "--working-directory" "/home/${username}/wiki/" "-e" "trinity"; }
      Mod+R { spawn "alacritty" "--class" "rmpc" "-e" "rmpc"; }

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
        spacing = 1;

        modules-left = [
          "niri/workspaces"
          "custom/routine"
          "custom/taskwarrior"
          "mpris"
          "niri/window"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "custom/wakatime"
          "custom/worklog"
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
          on-click = "pavucontrol";
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

        "custom/wakatime" = {
          format = "{}";
          return-type = "json";
          exec = "~/.local/bin/waybar-wakatime.sh";
          interval = 1200;
          tooltip = true;
        };

        "custom/taskwarrior" = {
          format = "{}";
          return-type = "json";
          exec = "~/.config/waybar/scripts/taskwarrior-status.sh";
          on-click = "~/.config/waybar/scripts/taskwarrior-status.sh shownext";
          on-click-right = "~/.config/waybar/scripts/taskwarrior-status.sh censor";
          interval = 5;
          tooltip = true;
        };

        "custom/worklog" = {
          exec = "~/.local/bin/worklog.sh status";
          return-type = "json";
          format = "{}";
          interval = 2;
          on-click = "~/.local/bin/worklog.sh toggle";
          on-click-middle = "~/.local/bin/worklog.sh pause";
          on-click-right = "~/.local/bin/worklog.sh compile";
          tooltip = true;
        };

        "custom/routine" = {
          exec = "~/.config/waybar/scripts/daily-routine.sh";
          return-type = "json";
          format = "{}";
          interval = 60;
          on-click = "bash -c 'if [[ -f /tmp/waybar-routine-show-label ]]; then rm /tmp/waybar-routine-show-label; else echo true > /tmp/waybar-routine-show-label; fi'";
          tooltip = true;
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

      #custom-wakatime {
        background-color: #2a273f;
        border-radius: 0;
        padding: 2px 10px;
        margin: 2px 4px;
        color: #3e8fb0;
        transition: all 0.2s ease;
      }

      #custom-wakatime:hover {
        background-color: #393552;
      }

      #custom-wakatime.error {
        color: #6e6a86;
      }

      #custom-worklog {
        background-color: #2a273f;
        border-radius: 0;
        padding: 2px 10px;
        margin: 2px 4px;
        color: #6e6a86;
        transition: all 0.2s ease;
      }

      #custom-worklog:hover {
        background-color: #393552;
      }

      #custom-worklog.recording {
        color: #eb6f92;
      }

      #custom-worklog.paused {
        color: #f6c177;
      }

      #custom-taskwarrior {
        background-color: #2a273f;
        border-radius: 0;
        padding: 2px 10px;
        margin: 2px 4px;
        color: #c4a7e7;
        transition: all 0.2s ease;
      }

      #custom-taskwarrior:hover {
        background-color: #393552;
      }

      #custom-taskwarrior.active {
        color: #9ccfd8;
      }

      #custom-taskwarrior.upcoming {
        color: #f6c177;
      }

      #custom-taskwarrior.overdue {
        color: #eb6f92;
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
    settings = {
      background-color = "#232136";
      text-color = "#e0def4";
      border-color = "#c4a7e7";
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

  home.file.".local/bin/waybar-wakatime.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      ICON=$'\uf121'
      CONFIG="$HOME/.wakatime.cfg"
      if [ ! -f "$CONFIG" ]; then
        echo "{\"text\": \"$ICON --\", \"tooltip\": \"No ~/.wakatime.cfg found\", \"class\": \"error\"}"
        exit 0
      fi

      API_KEY=$(grep -oP '^\s*api_key\s*=\s*\K\S+' "$CONFIG")
      API_URL=$(grep -oP '^\s*api_url\s*=\s*\K\S+' "$CONFIG")
      API_URL="''${API_URL:-http://localhost:3040/api}"

      if [ -z "$API_KEY" ]; then
        echo "{\"text\": \"$ICON --\", \"tooltip\": \"No api_key in ~/.wakatime.cfg\", \"class\": \"error\"}"
        exit 0
      fi

      TODAY=$(date +%Y-%m-%d)
      RESPONSE=$(curl -sf -H "Authorization: Basic $(echo -n "$API_KEY" | base64)" \
        "''${API_URL}/compat/wakatime/v1/users/current/summaries?start=$TODAY&end=$TODAY" 2>/dev/null)

      if [ $? -ne 0 ] || [ -z "$RESPONSE" ]; then
        echo "{\"text\": \"$ICON --\", \"tooltip\": \"Wakapi unreachable\", \"class\": \"error\"}"
        exit 0
      fi

      TOTAL_SECS=$(echo "$RESPONSE" | jq -r '(.data[0].editors[] | select(.name == "Neovim") | .total_seconds) // 0')
      TOTAL_SECS=''${TOTAL_SECS%.*}
      HOURS=$((TOTAL_SECS / 3600))
      MINS=$(( (TOTAL_SECS % 3600) / 60 ))
      TOTAL=$(printf " %02d:%02d" $HOURS $MINS)
      echo "{\"text\": \"$ICON $TOTAL\", \"tooltip\": \"Neovim today: $TOTAL\", \"class\": \"active\"}"
    '';
  };

  home.file.".local/bin/worklog.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      WORKLOG_DIR="$HOME/worklog"
      PID_FILE="/tmp/worklog.pid"
      STATE_FILE="/tmp/worklog.state"
      COUNT_FILE="/tmp/worklog.count"

      today() { date +%Y-%m-%d; }

      is_running() {
        [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null
      }

      cmd_daemon() {
        mkdir -p "$WORKLOG_DIR/$(today)"
        echo "running" > "$STATE_FILE"
        [ -f "$COUNT_FILE" ] || echo 0 > "$COUNT_FILE"

        while true; do
          if [ "$(cat "$STATE_FILE" 2>/dev/null)" = "running" ]; then
            TIMESTAMP=$(date +%H-%M-%S)
            TODAY_DIR="$WORKLOG_DIR/$(today)"
            mkdir -p "$TODAY_DIR"

            ffmpeg -f v4l2 -i /dev/video0 -frames:v 1 "$TODAY_DIR/$TIMESTAMP.jpg" -y -loglevel quiet 2>/dev/null

            COUNT=$(cat "$COUNT_FILE" 2>/dev/null || echo 0)
            echo $((COUNT + 1)) > "$COUNT_FILE"
          fi

          sleep 10
        done
      }

      cmd_toggle() {
        if is_running; then
          kill "$(cat "$PID_FILE")" 2>/dev/null
          rm -f "$PID_FILE" "$STATE_FILE" "$COUNT_FILE"
        else
          $0 daemon &
          echo $! > "$PID_FILE"
          disown
        fi
      }

      cmd_pause() {
        is_running || return
        CURRENT=$(cat "$STATE_FILE" 2>/dev/null)
        if [ "$CURRENT" = "running" ]; then
          echo "paused" > "$STATE_FILE"
        else
          echo "running" > "$STATE_FILE"
        fi
      }

      cmd_compile() {
        TODAY=$(today)
        DIR="$WORKLOG_DIR/$TODAY"
        OUTPUT="$WORKLOG_DIR/$TODAY.mp4"

        if [ ! -d "$DIR" ] || [ -z "$(ls -A "$DIR" 2>/dev/null)" ]; then
          notify-send "Worklog" "No frames found for $TODAY"
          return 1
        fi

        ffmpeg -framerate 30 -pattern_type glob -i "$DIR/*.jpg" \
          -c:v libx264 -pix_fmt yuv420p -y "$OUTPUT" 2>/dev/null

        if [ $? -eq 0 ]; then
          notify-send "Worklog" "Compiled $OUTPUT"
        else
          notify-send "Worklog" "Failed to compile timelapse"
        fi
      }

      cmd_status() {
        if ! is_running; then
          echo '{"text": "󰻂", "tooltip": "Worklog idle", "class": "idle"}'
          return
        fi

        STATE=$(cat "$STATE_FILE" 2>/dev/null)
        COUNT=$(cat "$COUNT_FILE" 2>/dev/null || echo 0)

        if [ "$STATE" = "paused" ]; then
          echo "{\"text\": \"󰻂 paused\", \"tooltip\": \"Worklog paused ($COUNT frames)\", \"class\": \"paused\"}"
        else
          echo "{\"text\": \"󰻂 $COUNT\", \"tooltip\": \"Recording ($COUNT frames)\", \"class\": \"recording\"}"
        fi
      }

      case "''${1:-status}" in
        toggle)  cmd_toggle ;;
        pause)   cmd_pause ;;
        compile) cmd_compile ;;
        status)  cmd_status ;;
        daemon)  cmd_daemon ;;
        *)       echo "Usage: $0 {toggle|pause|compile|status|daemon}" ;;
      esac
    '';
  };

  # Daily Routine Waybar integration
  home.file.".config/waybar/scripts/daily-routine.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Daily Routine Script for Waybar
      # Shows current routine phase with emoji icon

      # Configuration
      SHOW_LABEL_FILE="/tmp/waybar-routine-show-label"

      # Check if we should show label or just icon
      if [[ -f "$SHOW_LABEL_FILE" ]]; then
          SHOW_LABEL=$(cat "$SHOW_LABEL_FILE")
      else
          SHOW_LABEL="false"
      fi

      # Get current day and time
      DAY_OF_WEEK="''${DAY_OF_WEEK-"$(date +%u)"}"  # 1-7 (Monday-Sunday)
      CURRENT_HOUR="''${CURRENT_HOUR-"$(date +%H)"}"
      CURRENT_MIN="''${CURRENT_MIN-"$(date +%M)"}"
      CURRENT_TIME=$((CURRENT_HOUR * 60 + CURRENT_MIN))

      # Only show routine on weekdays (Monday-Friday, 1-5)
      if [[ $DAY_OF_WEEK -ge 1 && $DAY_OF_WEEK -le 5 ]]; then
          # Define routine phases (in minutes since midnight)
          MORNING_START=$((10 * 60))    # 10:00
          MORNING_END=$((11 * 60))      # 11:00
          
          FREE1_START=$((11 * 60))      # 11:00
          FREE1_END=$((13 * 60))        # 13:00 (1:00 PM)
          
          LIGHTWORK_START=$((13 * 60))   # 13:00 (1:00 PM)
          LIGHTWORK_END=$((17 * 60))    # 17:00 (5:00 PM)
          
          FREE2_START=$((17 * 60))      # 17:00 (5:00 PM)
          FREE2_END=$((23 * 60))        # 23:00 (11:00 PM)
          
          DEEPWORK_START=$((23 * 60))    # 23:00 (11:00 PM)
          
          # For times that span midnight, use minutes since midnight (0-1439)
          BEDTIME_START=$((1 * 60 + 30)) # 01:30 AM (90 minutes)
          BEDTIME_END=$((2 * 60))        # 02:00 AM (120 minutes)
          
          # Determine current phase
          if [[ $CURRENT_TIME -ge $MORNING_START && $CURRENT_TIME -lt $MORNING_END ]]; then
              ICON="☀"
              LABEL="Morning Routine"
              TOOLTIP="10:00-11:00: Morning Routine"
          elif [[ $CURRENT_TIME -ge $FREE1_START && $CURRENT_TIME -lt $FREE1_END ]]; then
              ICON="▲"
              LABEL="Free Time"
              TOOLTIP="11:00-13:00: Free Time"
          elif [[ $CURRENT_TIME -ge $LIGHTWORK_START && $CURRENT_TIME -lt $LIGHTWORK_END ]]; then
              ICON="○"
              LABEL="Light Work"
              TOOLTIP="13:00-17:00: Light Work"
          elif [[ $CURRENT_TIME -ge $FREE2_START && $CURRENT_TIME -lt $FREE2_END ]]; then
              ICON="▲"
              LABEL="Free Time"
              TOOLTIP="17:00-23:00: Free Time"
          elif [[ $CURRENT_TIME -ge $DEEPWORK_START || $CURRENT_TIME -lt $BEDTIME_START ]]; then
              ICON="●"
              LABEL="Deep Work"
              TOOLTIP="23:00-01:30: Deep Work"
          elif [[ $CURRENT_TIME -ge $BEDTIME_START && $CURRENT_TIME -lt $BEDTIME_END ]]; then
              ICON="◎"
              LABEL="Bedtime"
              TOOLTIP="01:30-02:00: Bedtime Routine"
          else
              # Outside routine hours
              ICON="◐"
              LABEL="Sleep"
              TOOLTIP="Sleep Time"
          fi
          
          # Output format
          if [[ "$SHOW_LABEL" == "true" ]]; then
              echo "{\"text\": \"$ICON $LABEL\", \"tooltip\": \"$TOOLTIP\", \"class\": \"routine\"}"
          else
              echo "{\"text\": \"$ICON\", \"tooltip\": \"$TOOLTIP\", \"class\": \"routine\"}"
          fi
      else
          # Weekend - show different icon
          echo "{\"text\": \"★\", \"tooltip\": \"Weekend!\", \"class\": \"routine\"}"
      fi
    '';
  };

  # Taskwarrior Waybar integration
  home.file.".config/waybar/scripts/taskwarrior-status.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -eEo pipefail

      CAL_ICON=$'\uf073'
      CENSOR_FILE="/tmp/waybar-task-censor"
      SHOWNEXT_FILE="/tmp/waybar-task-shownext"
      SHOWNEXT_DURATION=5

      # Handle click actions
      if [ "$1" = "censor" ]; then
        if [ -f "$CENSOR_FILE" ]; then
          rm -f "$CENSOR_FILE"
        else
          touch "$CENSOR_FILE"
        fi
        exit 0
      fi

      if [ "$1" = "shownext" ]; then
        touch "$SHOWNEXT_FILE"
        exit 0
      fi

      output_json() {
        local text=$1
        local class=$2
        local tooltip=$3
        tooltip=$(echo "$tooltip" | sed 's/\\/\\\\/g; s/"/\\"/g')
        echo "{\"text\":\"$text\",\"class\":\"$class\",\"tooltip\":\"$tooltip\"}"
      }

      fmt_duration() {
        local total_mins=$1
        local abs_mins=''${total_mins#-}

        if [ "$abs_mins" -ge 1440 ]; then
          local d=$((abs_mins / 1440))
          local h=$(((abs_mins % 1440) / 60))
          echo "''${d}d''${h}h"
        elif [ "$abs_mins" -ge 60 ]; then
          local h=$((abs_mins / 60))
          local m=$((abs_mins % 60))
          echo "''${h}h''${m}m"
        else
          echo "''${abs_mins}m"
        fi
      }

      # Convert taskwarrior date format (20260228T235959Z) to epoch
      tw_date_to_epoch() {
        local tw_date=$1
        # Convert 20260228T235959Z to 2026-02-28T23:59:59Z
        local iso_date=$(echo "$tw_date" | sed 's/\([0-9]\{4\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)T\([0-9]\{2\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)Z/\1-\2-\3T\4:\5:\6Z/')
        date -d "$iso_date" +%s 2>/dev/null || echo 0
      }

      # Check state flags
      censor_mode=0
      [ -f "$CENSOR_FILE" ] && censor_mode=1

      shownext_mode=0
      if [ -f "$SHOWNEXT_FILE" ]; then
        shownext_mtime=$(stat -c %Y "$SHOWNEXT_FILE" 2>/dev/null || echo 0)
        now=$(date +%s)
        if [ $((now - shownext_mtime)) -lt $SHOWNEXT_DURATION ]; then
          shownext_mode=1
        else
          rm -f "$SHOWNEXT_FILE"
        fi
      fi

      # Get active task (started)
      active_task=$(task +ACTIVE export 2>/dev/null | jq -r '.[0] // empty')

      # Get next task by due date (only tasks with due dates)
      next_due_task=$(task +PENDING due.any: export 2>/dev/null | jq -r 'sort_by(.due) | .[0] // empty')

      # Get upcoming tasks for tooltip (top 10 by due date)
      upcoming_tasks=$(task +PENDING due.any: export 2>/dev/null | jq -r 'sort_by(.due) | .[0:10]')

      # Build tooltip
      tooltip="<b>Tasks</b>&#10;&#10;"

      if [ -n "$active_task" ] && [ "$active_task" != "null" ]; then
        active_desc=$(echo "$active_task" | jq -r '.description // "Unknown"')
        active_start=$(echo "$active_task" | jq -r '.start // empty')
        if [ -n "$active_start" ]; then
          start_epoch=$(tw_date_to_epoch "$active_start")
          now_epoch=$(date +%s)
          elapsed_mins=$(( (now_epoch - start_epoch) / 60 ))
          elapsed_str=$(fmt_duration $elapsed_mins)
          tooltip+="<span foreground='#9ccfd8'><b>Active:</b></span> $active_desc <span size='small' foreground='#9ccfd8'>($elapsed_str)</span>&#10;&#10;"
        fi
      fi

      # Add upcoming tasks to tooltip
      task_count=$(echo "$upcoming_tasks" | jq -r 'length')
      if [ "$task_count" -gt 0 ]; then
        tooltip+="<b>Upcoming:</b>&#10;"
        for i in $(seq 0 $((task_count - 1))); do
          task_item=$(echo "$upcoming_tasks" | jq -r ".[$i]")
          desc=$(echo "$task_item" | jq -r '.description // "Unknown"')
          due=$(echo "$task_item" | jq -r '.due // empty')
          project=$(echo "$task_item" | jq -r '.project // empty')

          if [ -n "$due" ]; then
            due_epoch=$(tw_date_to_epoch "$due")
            now_epoch=$(date +%s)
            diff_mins=$(( (due_epoch - now_epoch) / 60 ))

            if [ $diff_mins -lt 0 ]; then
              time_str="<span foreground='#eb6f92'>overdue by $(fmt_duration $diff_mins)</span>"
            else
              time_str="in $(fmt_duration $diff_mins)"
            fi

            proj_str=""
            [ -n "$project" ] && proj_str="<span alpha='60%'>[$project]</span> "

            tooltip+="  $proj_str$desc <span size='small' alpha='60%'>($time_str)</span>&#10;"
          fi
        done
      else
        tooltip+="<span alpha='60%'>No tasks with due dates</span>"
      fi

      # Determine what to display
      display_task=""
      display_time=""
      display_class="default"
      is_active=0

      if [ "$shownext_mode" -eq 1 ] && [ -n "$next_due_task" ] && [ "$next_due_task" != "null" ]; then
        # Show next due task (forced by click)
        display_task=$(echo "$next_due_task" | jq -r '.description // "Unknown"')
        due=$(echo "$next_due_task" | jq -r '.due // empty')
        if [ -n "$due" ]; then
          due_epoch=$(tw_date_to_epoch "$due")
          now_epoch=$(date +%s)
          diff_mins=$(( (due_epoch - now_epoch) / 60 ))
          display_time=$(fmt_duration $diff_mins)
          if [ $diff_mins -lt 0 ]; then
            display_class="overdue"
            display_time="-$display_time"
          else
            display_class="upcoming"
            display_time="~$display_time"
          fi
        fi
      elif [ -n "$active_task" ] && [ "$active_task" != "null" ]; then
        # Show active task
        display_task=$(echo "$active_task" | jq -r '.description // "Unknown"')
        start_ts=$(echo "$active_task" | jq -r '.start // empty')
        if [ -n "$start_ts" ]; then
          start_epoch=$(tw_date_to_epoch "$start_ts")
          now_epoch=$(date +%s)
          elapsed_mins=$(( (now_epoch - start_epoch) / 60 ))
          display_time="+$(fmt_duration $elapsed_mins)"
        fi
        display_class="active"
        is_active=1
      elif [ -n "$next_due_task" ] && [ "$next_due_task" != "null" ]; then
        # Show next due task
        display_task=$(echo "$next_due_task" | jq -r '.description // "Unknown"')
        due=$(echo "$next_due_task" | jq -r '.due // empty')
        if [ -n "$due" ]; then
          due_epoch=$(tw_date_to_epoch "$due")
          now_epoch=$(date +%s)
          diff_mins=$(( (due_epoch - now_epoch) / 60 ))
          display_time=$(fmt_duration $diff_mins)
          if [ $diff_mins -lt 0 ]; then
            display_class="overdue"
            display_time="-$display_time"
          else
            display_class="upcoming"
            display_time="~$display_time"
          fi
        fi
      fi

      # Build output
      if [ -z "$display_task" ]; then
        output_json "$CAL_ICON" "default" "$tooltip"
        exit 0
      fi

      # Truncate long titles
      if [ ''${#display_task} -gt 25 ]; then
        display_task="''${display_task:0:23}.."
      fi

      # Apply censoring
      if [ "$censor_mode" -eq 1 ]; then
        # Create stars matching length
        censored_task=$(echo "$display_task" | sed 's/./*/g')
        censored_time="****"
        output_json "$CAL_ICON $censored_task ($censored_time)" "$display_class" "$tooltip"
      else
        output_json "$CAL_ICON $display_task ($display_time)" "$display_class" "$tooltip"
      fi
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
    theme = {
      manager = {
        cwd = {
          fg = "#9ccfd8";
        };
        hovered = {
          fg = "#232136";
          bg = "#c4a7e7";
        };
        preview_hovered = {
          underline = true;
        };
        find_keyword = {
          fg = "#f6c177";
          bold = true;
        };
        find_position = {
          fg = "#ea9a97";
          bg = "reset";
          bold = true;
        };
        marker_copied = {
          fg = "#9ccfd8";
          bg = "#9ccfd8";
        };
        marker_cut = {
          fg = "#eb6f92";
          bg = "#eb6f92";
        };
        marker_selected = {
          fg = "#c4a7e7";
          bg = "#c4a7e7";
        };
        tab_active = {
          fg = "#232136";
          bg = "#c4a7e7";
        };
        tab_inactive = {
          fg = "#e0def4";
          bg = "#2a273f";
        };
        tab_width = 1;
        border_symbol = "│";
        border_style = {
          fg = "#393552";
        };
        count_copied = {
          fg = "#232136";
          bg = "#9ccfd8";
        };
        count_cut = {
          fg = "#232136";
          bg = "#eb6f92";
        };
        count_selected = {
          fg = "#232136";
          bg = "#c4a7e7";
        };
      };
      status = {
        separator_open = "";
        separator_close = "";
        separator_style = {
          fg = "#2a273f";
          bg = "#2a273f";
        };
        mode_normal = {
          fg = "#232136";
          bg = "#c4a7e7";
          bold = true;
        };
        mode_select = {
          fg = "#232136";
          bg = "#9ccfd8";
          bold = true;
        };
        mode_unset = {
          fg = "#232136";
          bg = "#eb6f92";
          bold = true;
        };
        progress_label = {
          fg = "#e0def4";
          bold = true;
        };
        progress_normal = {
          fg = "#393552";
          bg = "#2a273f";
        };
        progress_error = {
          fg = "#eb6f92";
          bg = "#2a273f";
        };
        permissions_t = {
          fg = "#9ccfd8";
        };
        permissions_r = {
          fg = "#f6c177";
        };
        permissions_w = {
          fg = "#eb6f92";
        };
        permissions_x = {
          fg = "#9ccfd8";
        };
        permissions_s = {
          fg = "#6e6a86";
        };
      };
      input = {
        border = {
          fg = "#c4a7e7";
        };
        title = { };
        value = { };
        selected = {
          reversed = true;
        };
      };
      select = {
        border = {
          fg = "#c4a7e7";
        };
        active = {
          fg = "#ea9a97";
        };
        inactive = { };
      };
      tasks = {
        border = {
          fg = "#c4a7e7";
        };
        title = { };
        hovered = {
          underline = true;
        };
      };
      which = {
        mask = {
          bg = "#2a273f";
        };
        cand = {
          fg = "#9ccfd8";
        };
        rest = {
          fg = "#6e6a86";
        };
        desc = {
          fg = "#ea9a97";
        };
        separator = "  ";
        separator_style = {
          fg = "#393552";
        };
      };
      help = {
        on = {
          fg = "#ea9a97";
        };
        run = {
          fg = "#9ccfd8";
        };
        desc = {
          fg = "#6e6a86";
        };
        hovered = {
          bg = "#393552";
          bold = true;
        };
        footer = {
          fg = "#e0def4";
          bg = "#2a273f";
        };
      };
      filetype = {
        rules = [
          {
            mime = "image/*";
            fg = "#9ccfd8";
          }
          {
            mime = "video/*";
            fg = "#f6c177";
          }
          {
            mime = "audio/*";
            fg = "#f6c177";
          }
          {
            mime = "application/zip";
            fg = "#ea9a97";
          }
          {
            mime = "application/gzip";
            fg = "#ea9a97";
          }
          {
            mime = "application/x-tar";
            fg = "#ea9a97";
          }
          {
            mime = "application/x-bzip";
            fg = "#ea9a97";
          }
          {
            mime = "application/x-bzip2";
            fg = "#ea9a97";
          }
          {
            mime = "application/x-7z-compressed";
            fg = "#ea9a97";
          }
          {
            mime = "application/x-rar";
            fg = "#ea9a97";
          }
          {
            name = "*";
            fg = "#e0def4";
          }
          {
            name = "*/";
            fg = "#c4a7e7";
          }
        ];
      };
    };
  };

  # Zathura document viewer with Rose Pine Moon
  programs.zathura = {
    enable = true;
    options = {
      # Rose Pine Moon colors
      default-bg = "#232136";
      default-fg = "#e0def4";
      statusbar-bg = "#2a273f";
      statusbar-fg = "#e0def4";
      inputbar-bg = "#2a273f";
      inputbar-fg = "#e0def4";
      notification-bg = "#2a273f";
      notification-fg = "#e0def4";
      notification-error-bg = "#2a273f";
      notification-error-fg = "#eb6f92";
      notification-warning-bg = "#2a273f";
      notification-warning-fg = "#f6c177";
      highlight-color = "#f6c177";
      highlight-active-color = "#c4a7e7";
      completion-bg = "#2a273f";
      completion-fg = "#e0def4";
      completion-highlight-bg = "#393552";
      completion-highlight-fg = "#e0def4";
      recolor = true;
      recolor-lightcolor = "#232136";
      recolor-darkcolor = "#e0def4";
      recolor-keephue = true;
    };
  };

}
