{
  config,
  pkgs,
  lib,
  ...
}:

let
  waybar-timer-src = pkgs.fetchFromGitHub {
    owner = "nirabyte";
    repo = "waybar-timer";
    rev = "main";
    sha256 = "sha256-2R4dpTbv8OPxVdHjjymdNzegePYzacdHKogOnTO8/qY=";
  };
in

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
    spawn-at-startup "wl-paste" "--watch" "cliphist" "store"
    spawn-at-startup "swayidle" "-w" "timeout" "1800" "swaylock -f" "timeout" "2700" "niri msg action power-off-monitors" "resume" "niri msg action power-on-monitors" "before-sleep" "swaylock -f"
    spawn-at-startup "nm-applet" "--indicator"

    // Cursor
    cursor {
      xcursor-theme "Bibata-Modern-Classic"
      xcursor-size 20
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
      match title="Taskwarrior"
      default-column-width { proportion 0.3; }
    }

       // Keybindings
    binds {
      // Mod = Super/Logo key
      Mod+T { spawn "alacritty"; }
      Mod+D { spawn "wofi" "--show" "drun"; }
      Mod+B { spawn "zen"; }
      Ctrl+Shift+W { spawn "bash" "-c" "~/wofi/launcher.sh"; }
      Mod+S { spawn "flatpak" "run" "net.mkiol.SpeechNote"; }
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

      // Speedrunning
      Mod+Y { spawn "openspeedrun-cli" "split"; }
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
        spacing = 8;

        modules-left = [
          "niri/workspaces"
          "niri/window"
          "mpris"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "custom/taskwarrior"
          "custom/wakatime"
          "custom/worklog"
          "custom/timer"
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

        "custom/timer" = {
          exec = "bash ~/.local/bin/waybar-timer.sh";
          return-type = "json";
          format = "{}";
          on-click = "bash ~/.local/bin/waybar-timer.sh click";
          on-click-right = "bash ~/.local/bin/waybar-timer.sh right";
          on-click-middle = "bash ~/.local/bin/waybar-timer.sh middle";
          on-scroll-up = "bash ~/.local/bin/waybar-timer.sh down";
          on-scroll-down = "bash ~/.local/bin/waybar-timer.sh up";
          tooltip = true;
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
          interval = 60;
          tooltip = true;
          on-click = "alacritty --title Taskwarrior -e bash -c '~/.config/waybar/scripts/taskwarrior-add.sh'";
          on-click-right = "alacritty --title Taskwarrior -e bash -c '~/.config/waybar/scripts/taskwarrior-done.sh'";
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

      #custom-timer {
        background-color: #2a273f;
        border-radius: 0;
        padding: 2px 10px;
        margin: 2px 4px;
        color: #e0def4;
        transition: all 0.2s ease;
      }

      #custom-timer:hover {
        background-color: #393552;
      }

      #custom-timer.disabled,
      #custom-timer.reset {
        color: #6e6a86;
      }

      #custom-timer.idle {
        color: #908caa;
      }

      #custom-timer.select,
      #custom-timer.pomo_msg {
        color: #c4a7e7;
      }

      #custom-timer.running {
        color: #9ccfd8;
      }

      #custom-timer.paused,
      #custom-timer.warning {
        color: #f6c177;
      }

      #custom-timer.pomo_break {
        color: #ea9a97;
      }

      #custom-timer.done {
        color: #eb6f92;
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

      #custom-taskwarrior.due {
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

  home.file.".local/bin/waybar-timer.sh" = {
    executable = true;
    text = builtins.replaceStrings [ "#!/bin/bash" ] [ "#!/usr/bin/env bash" ] (
      builtins.readFile "${waybar-timer-src}/timer.sh"
    );
  };

  home.file.".config/waybar/sounds/timer.mp3" = {
    source = "${waybar-timer-src}/sounds/timer.mp3";
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

            grim /tmp/worklog-screen.png

            WEBCAM_OK=false
            if ffmpeg -f v4l2 -i /dev/video0 -frames:v 1 /tmp/worklog-webcam.jpg -y -loglevel quiet 2>/dev/null; then
              WEBCAM_OK=true
            fi

            if [ "$WEBCAM_OK" = true ]; then
              magick /tmp/worklog-screen.png \
                \( /tmp/worklog-webcam.jpg -resize 320x -background none \
                   -bordercolor '#232136' -border 3 \) \
                -gravity SouthEast -geometry +20+20 -composite \
                "$TODAY_DIR/$TIMESTAMP.jpg"
            else
              magick /tmp/worklog-screen.png "$TODAY_DIR/$TIMESTAMP.jpg"
            fi

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

  # Taskwarrior Waybar integration scripts
  # https://github.com/coccor/taskwarrior-waybar
  home.file.".config/waybar/scripts/humanize-date.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -eEo pipefail

      input_date="$1"

      if [ -z "$input_date" ]; then
        echo "Error: No date provided" >&2
        exit 1
      fi

      parse_date() {
        local date="$1"
        if [[ "$date" =~ ^[0-9]{8}T[0-9]{6}Z$ ]]; then
          echo "$date" | sed 's/\([0-9]\{4\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)T\([0-9]\{2\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)Z/\1-\2-\3T\4:\5:\6Z/'
        else
          echo "$date"
        fi
      }

      parsed_date=$(parse_date "$input_date")
      date_seconds=$(date --date="$parsed_date" +%s 2>/dev/null || { echo "Error: Invalid date format" >&2; exit 1; })

      now_seconds=$(date +%s)
      diff=$((date_seconds - now_seconds))

      date_only=$(date --date="$parsed_date" +%Y-%m-%d 2>/dev/null)
      today=$(date +%Y-%m-%d)
      tomorrow=$(date --date="tomorrow" +%Y-%m-%d)
      yesterday=$(date --date="yesterday" +%Y-%m-%d)

      if [ "$date_only" = "$today" ]; then
        if [ "$diff" -gt 0 ]; then
          hours=$((diff / 3600))
          minutes=$(((diff % 3600) / 60))
          if [ "$hours" -gt 0 ]; then
            echo "today in ''${hours}h''${minutes}m"
          else
            echo "today in ''${minutes}m"
          fi
        else
          diff=$(( -diff ))
          hours=$((diff / 3600))
          minutes=$(((diff % 3600) / 60))
          if [ "$hours" -gt 0 ]; then
            echo "today ''${hours}h''${minutes}m ago"
          else
            echo "today ''${minutes}m ago"
          fi
        fi
      elif [ "$date_only" = "$tomorrow" ]; then
        hours=$((diff / 3600))
        remaining_hours=$((hours % 24))
        if [ "$remaining_hours" -gt 0 ]; then
          echo "tomorrow at $(date --date="$parsed_date" +%H:%M)"
        else
          echo "tomorrow"
        fi
      elif [ "$date_only" = "$yesterday" ]; then
        echo "yesterday"
      elif [ "$diff" -gt 86400 ]; then
        days=$((diff / 86400))
        echo "in ''${days}d"
      elif [ "$diff" -gt 0 ]; then
        hours=$((diff / 3600))
        minutes=$(((diff % 3600) / 60))
        echo "in ''${hours}h''${minutes}m"
      else
        diff=$(( -diff ))
        if [ "$diff" -gt 86400 ]; then
          days=$((diff / 86400))
          echo "''${days}d ago"
        else
          hours=$((diff / 3600))
          minutes=$(((diff % 3600) / 60))
          echo "''${hours}h''${minutes}m ago"
        fi
      fi
    '';
  };

  home.file.".config/waybar/scripts/taskwarrior-status.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -eEo pipefail

      SCRIPT_DIR="$(dirname "''${BASH_SOURCE[0]}")"
      HUMANIZE_DATE="$SCRIPT_DIR/humanize-date.sh"
      TASK_ICON=$'\uf0ae'

      output_status() {
        local state=$1
        local tooltip=$2
        local icon=$3
        tooltip=$(echo "$tooltip" | sed 's/\\/\\\\/g; s/"/\\"/g')
        echo "{\"text\":\"$icon\",\"class\":\"''${state}\",\"tooltip\":\"$tooltip\"}"
      }

      tasks_json=$(task +PENDING export 2>/dev/null | jq 'sort_by(.due // "9999") | .[0:10]' 2>/dev/null) || tasks_json="[]"

      if task +PENDING due.before:now count 2>/dev/null | grep -q '[1-9]'; then
        state="due"
        icon="$TASK_ICON !"
      else
        state="default"
        icon="$TASK_ICON"
      fi

      tooltip=""
      if [ -n "$tasks_json" ] && [ "$tasks_json" != "[]" ]; then
        task_count=$(echo "$tasks_json" | jq 'length')
        overdue_count=$(task +PENDING +OVERDUE count 2>/dev/null || echo 0)

        tooltip="<b>Tasks</b> <span size='small'>($task_count pending"
        if [ "$overdue_count" -gt 0 ]; then
          tooltip+=", <span foreground='#ff6b6b'>$overdue_count overdue</span>"
        fi
        tooltip+=") </span>&#10;&#10;"

        while IFS= read -r task; do
          desc=$(echo "$task" | jq -r '.description')
          due=$(echo "$task" | jq -r '.due // empty')
          priority=$(echo "$task" | jq -r '.priority // empty')

          if [ -n "$due" ]; then
            rel_due=$("$HUMANIZE_DATE" "$due" 2>/dev/null || echo "invalid date")
          else
            rel_due="no due"
          fi

          priority_icon=""
          case "$priority" in
            H) priority_icon="<span foreground='#ff6b6b'>!</span> " ;;
            M) priority_icon="<span foreground='#feca57'>-</span> " ;;
            L) priority_icon="<span foreground='#48dbfb'>-</span> " ;;
          esac

          if [[ "$rel_due" =~ ago ]] || [[ "$rel_due" = "yesterday" ]]; then
            tooltip+="''${priority_icon}<span foreground='#ff6b6b'><b>$desc</b></span>"
            tooltip+=" <span size='small' foreground='#ff6b6b'>$rel_due</span>&#10;"
          elif [[ "$rel_due" = "today"* ]]; then
            tooltip+="''${priority_icon}<span foreground='#feca57'><b>$desc</b></span>"
            tooltip+=" <span size='small' foreground='#feca57'>$rel_due</span>&#10;"
          elif [[ "$rel_due" = "tomorrow"* ]]; then
            tooltip+="''${priority_icon}<b>$desc</b>"
            tooltip+=" <span size='small' foreground='#48dbfb'>$rel_due</span>&#10;"
          else
            tooltip+="''${priority_icon}$desc"
            tooltip+=" <span size='small' alpha='60%'>$rel_due</span>&#10;"
          fi
        done < <(echo "$tasks_json" | jq -c '.[]')
      else
        tooltip="<b>Tasks</b>&#10;&#10;<span alpha='60%'>No pending tasks</span>"
      fi

      output_status "$state" "$tooltip" "$icon"
    '';
  };

  home.file.".config/waybar/scripts/taskwarrior-add.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      echo -n "Task description: "
      read desc
      [ -z "$desc" ] && exit 0

      echo -n "Due (e.g., 5min, 1h, 2d, tomorrow) - optional: "
      read due

      if [ -n "$due" ]; then
        if [[ "$due" =~ ^[0-9]+[smhdwy]+$ ]]; then
          due="now+$due"
        fi
        task add "$desc" due:$due >/dev/null
      else
        task add "$desc" >/dev/null
      fi

      echo "Task added: $desc"
      task synchronize 2>/dev/null
      read -p "Press Enter to exit..."
    '';
  };

  home.file.".config/waybar/scripts/taskwarrior-done.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -eEo pipefail

      tasks=$(task +PENDING rc.verbose=nothing rc.report.next.columns:id,description rc.report.next.labels:ID,Description next 2>/dev/null)

      if [ -z "$tasks" ] || ! echo "$tasks" | grep -q '[0-9]'; then
        notify-send "No pending tasks"
        echo "No pending tasks"
        read -p "Press Enter to exit..."
        exit 0
      fi

      echo "=== Pending Tasks ==="
      echo "$tasks"
      echo ""

      task_ids=$(task +PENDING rc.verbose=nothing rc.report.next.columns:id rc.report.next.labels:ID next 2>/dev/null | grep -E '^[[:space:]]*[0-9]+' | awk '{print $1}')
      task_count=$(echo "$task_ids" | wc -l)

      if [ "$task_count" -eq 0 ]; then
        notify-send "No pending tasks"
        echo "No pending tasks"
        read -p "Press Enter to exit..."
        exit 0
      fi

      echo -n "Enter task ID to mark done (or press Enter for most urgent): "
      read chosen_id

      if [ -z "$chosen_id" ]; then
        chosen_id=$(echo "$task_ids" | head -n1)
      fi

      if ! echo "$task_ids" | grep -q "^''${chosen_id}$"; then
        echo "Invalid task ID: $chosen_id"
        read -p "Press Enter to exit..."
        exit 1
      fi

      desc=$(task _get "''${chosen_id}.description" 2>/dev/null)
      task done "$chosen_id" >/dev/null 2>&1

      notify-send "Task completed" "$desc"
      echo "Task completed: $desc"
      task synchronize 2>/dev/null
      read -p "Press Enter to exit..."
    '';
  };

  home.file.".config/waybar/scripts/taskwarrior-notify.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -eEo pipefail

      SCRIPT_DIR="$(dirname "''${BASH_SOURCE[0]}")"
      HUMANIZE_DATE="$SCRIPT_DIR/humanize-date.sh"

      overdue_tasks=$(task +PENDING +OVERDUE export 2>/dev/null || echo "[]")
      due_soon_tasks=$(task +PENDING due.before:now+5min export 2>/dev/null || echo "[]")

      all_due_tasks=$(echo "$overdue_tasks$due_soon_tasks" | jq -s 'add | unique_by(.uuid)' 2>/dev/null || echo "[]")

      if [ -n "$all_due_tasks" ] && [ "$all_due_tasks" != "[]" ] && [ "$all_due_tasks" != "null" ]; then
        count=$(echo "$all_due_tasks" | jq 'length')
        overdue_count=$(echo "$overdue_tasks" | jq 'length' 2>/dev/null || echo 0)

        if [ "$overdue_count" -gt 0 ]; then
          msg="$overdue_count overdue, $((count - overdue_count)) due soon"
        else
          msg="$count task(s) due soon"
        fi

        list=""
        while IFS= read -r task; do
          desc=$(echo "$task" | jq -r '.description')
          due=$(echo "$task" | jq -r '.due // empty')

          if [ -n "$due" ]; then
            rel_due=$("$HUMANIZE_DATE" "$due" 2>/dev/null || echo "")
            if [ -n "$rel_due" ]; then
              list+="- $desc ($rel_due)\n"
            else
              list+="- $desc\n"
            fi
          else
            list+="- $desc\n"
          fi
        done < <(echo "$all_due_tasks" | jq -c '.[]' | head -n5)

        notify-send -u critical -t 10000 "Taskwarrior Reminder" "$msg\n\n$list"
      fi
    '';
  };

  # Taskwarrior notification timer
  systemd.user.services.taskwarrior-notify = {
    Unit.Description = "Taskwarrior due task notifications";
    Service = {
      Type = "oneshot";
      ExecStart = "%h/.config/waybar/scripts/taskwarrior-notify.sh";
    };
  };

  systemd.user.timers.taskwarrior-notify = {
    Unit.Description = "Run Taskwarrior notifications every 5 minutes";
    Timer = {
      OnBootSec = "1min";
      OnUnitActiveSec = "45min";
      Unit = "taskwarrior-notify.service";
    };
    Install.WantedBy = [ "default.target" ];
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
