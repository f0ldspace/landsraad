{
  config,
  pkgs,
  lib,
  username,
  ...
}:

# Catppuccin Mocha colors:
# base:      #1e1e2e
# mantle:    #181825
# crust:     #11111b
# surface0:  #313244
# surface1:  #45475a
# surface2:  #585b70
# overlay0:  #6c7086
# overlay1:  #7f849c
# overlay2:  #9399b2
# text:      #cdd6f4
# subtext1:  #bac2de
# subtext0:  #a6adc8
# rosewater: #f5e0dc
# flamingo:  #f2cdcd
# pink:      #f5c2e7
# mauve:     #cba6f7
# red:       #f38ba8
# maroon:    #eba0ac
# peach:     #fab387
# yellow:    #f9e2af
# green:     #a6e3a1
# teal:      #94e2d5
# sky:       #89dceb
# sapphire:  #74c7ec
# blue:      #89b4fa
# lavender:  #b4befe

{
  home.pointerCursor = {
    gtk.enable = true;
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
      cursor-theme = "catppuccin-mocha-mauve-cursors";
      cursor-size = 24;
      gtk-theme = "catppuccin-mocha-mauve-standard+default";
      icon-theme = "Papirus-Dark";
      color-scheme = "prefer-dark";
    };
  };

  # GTK theming
  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-mocha-mauve-standard+default";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        variant = "mocha";
      };
    };
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
      center-focused-column "always"

      preset-column-widths {
        proportion 0.33333
        proportion 0.5
        proportion 0.66667
        proportion 1.0
      }

      default-column-width { proportion 1.0; }

      focus-ring {
        width 2
        active-color "#cba6f7"
        inactive-color "#313244"
      }

      border {
        off
      }
    }

    // Spawn at startup
    spawn-at-startup "xwayland-satellite"
    spawn-at-startup "quickshell"
    spawn-at-startup "mako"
    spawn-at-startup "swww-daemon"
    spawn-at-startup "wl-paste" "--watch" "cliphist" "store"
    spawn-at-startup "swayidle" "-w" "timeout" "1800" "swaylock -f" "timeout" "2700" "niri msg action power-off-monitors" "resume" "niri msg action power-on-monitors" "before-sleep" "swaylock -f"
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
      geometry-corner-radius 10
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
      match app-id="Slack"
      default-column-width { proportion 0.4; }
    }

    window-rule {
      match title="Huddle:"
      default-column-width { proportion 0.2; }
    }

    window-rule {
      match app-id="obsidian"
      default-column-width { proportion 0.3; }
    }

    window-rule {
      match app-id="wiki-nvim"
      default-column-width { proportion 0.3; }
    }


       // Keybindings
    binds {
      // Mod = Super/Logo key
      Mod+Tab { focus-workspace-down; }
      Mod+Return { spawn "alacritty"; }
      Mod+D { spawn "wofi" "--show" "drun"; }
      Mod+B { spawn "zen"; }
      Mod+Q { close-window; }
      Mod+Shift+Q { close-window; } // Niri doesn't distinguish kill from close
      Mod+Shift+W { spawn "alacritty" "--working-directory" "/home/${username}/wiki/" "-e" "opencode" "--agent" "wiki"; }
      Mod+W { spawn "alacritty" "--class" "wiki-nvim" "--working-directory" "/home/${username}/wiki/" "-e" "codium"; }

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

      // Yazi file manager
      Mod+Y { spawn "alacritty" "--class" "yazi" "-e" "yazi"; }

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

      // Screenshot with annotation tools
      Mod+Print { spawn "bash" "-c" "grim -g \"$(slurp)\" - | satty -f -"; }
      Mod+Alt+S { spawn "bash" "-c" "grim -g \"$(slurp)\" - | swappy -f -"; }

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

  # Quickshell bar — entry point
  xdg.configFile."quickshell/shell.qml".text = ''
    import QtQuick
    import Quickshell

    ShellRoot {
      Bar {}
    }
  '';

  # Quickshell bar — main component
  xdg.configFile."quickshell/Bar.qml".text = ''
    import QtQuick
    import QtQuick.Layouts
    import Quickshell
    import Quickshell.Io
    import Quickshell.Services.SystemTray

    PanelWindow {
      id: root
      anchors.top: true
      anchors.left: true
      anchors.right: true
      implicitHeight: 36
      color: "transparent"

      // Catppuccin Mocha palette
      readonly property color cBase:     "#1e1e2e"
      readonly property color cMantle:   "#181825"
      readonly property color cSurface0: "#313244"
      readonly property color cOverlay0: "#6c7086"
      readonly property color cText:     "#cdd6f4"
      readonly property color cMauve:    "#cba6f7"
      readonly property color cRed:      "#f38ba8"
      readonly property color cYellow:   "#f9e2af"
      readonly property color cGreen:    "#a6e3a1"
      readonly property color cTeal:     "#94e2d5"

      // State
      property var  workspaces: []
      property int  activeWsId: -1
      property int  battery:    100
      property bool charging:   false
      property int  volume:     100
      property bool muted:      false
      property string media:    ""

      // Niri workspace event stream (real-time updates)
      Process {
        id: niriStream
        command: ["niri", "msg", "--json", "event-stream"]
        running: true
        stdout: SplitParser {
          onRead: line => {
            try {
              const ev = JSON.parse(line)
              if (ev.WorkspacesChanged) {
                root.workspaces = ev.WorkspacesChanged.workspaces
                for (const ws of ev.WorkspacesChanged.workspaces) {
                  if (ws.is_active) { root.activeWsId = ws.id; break }
                }
              }
            } catch (_) {}
          }
        }
      }

      // Battery capacity
      Process {
        id: pBatCap
        running: true
        command: ["sh", "-c", "cat /sys/class/power_supply/BAT1/capacity 2>/dev/null || cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo 100"]
        stdout: StdioCollector { onReadyRead: root.battery = parseInt(readAll()) || 100 }
      }

      // Battery charging status
      Process {
        id: pBatStat
        running: true
        command: ["sh", "-c", "cat /sys/class/power_supply/BAT1/status 2>/dev/null || cat /sys/class/power_supply/BAT0/status 2>/dev/null || echo Discharging"]
        stdout: StdioCollector {
          onReadyRead: {
            const s = readAll().trim()
            root.charging = s === "Charging" || s === "Full"
          }
        }
      }

      // Audio volume
      Process {
        id: pVol
        running: true
        command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@"]
        stdout: StdioCollector {
          onReadyRead: {
            const out = readAll().trim()
            const m = out.match(/Volume:\s*([\d.]+)/)
            if (m) root.volume = Math.round(parseFloat(m[1]) * 100)
            root.muted = out.includes("[MUTED]")
          }
        }
      }

      // Media title via playerctl
      Process {
        id: pMedia
        running: true
        command: ["playerctl", "metadata", "--format", "{{title}}"]
        stdout: StdioCollector { onReadyRead: root.media = readAll().trim() }
        onExited: (code, _) => { if (code !== 0) root.media = "" }
      }

      // Shared process for workspace focus actions
      Process { id: pWsAction; command: ["true"] }

      // Poll battery/audio/media every 5s
      Timer {
        interval: 5000; running: true; repeat: true
        onTriggered: {
          pBatCap.running = true
          pBatStat.running = true
          pVol.running = true
          pMedia.running = true
        }
      }

      // Bar background
      Rectangle {
        anchors { fill: parent; margins: 4; topMargin: 4 }
        color: Qt.rgba(30/255, 30/255, 46/255, 0.85)
        radius: 8

        RowLayout {
          anchors { fill: parent; leftMargin: 12; rightMargin: 12 }
          spacing: 0

          // Left: workspaces + now-playing
          RowLayout {
            spacing: 2

            Repeater {
              model: root.workspaces
              delegate: Rectangle {
                required property var modelData
                implicitWidth: 26; implicitHeight: 22; radius: 4
                color: modelData.id === root.activeWsId ? root.cSurface0 : "transparent"
                Text {
                  anchors.centerIn: parent
                  text: (modelData.idx + 1).toString()
                  color: modelData.id === root.activeWsId ? root.cMauve : root.cOverlay0
                  font.family: "JetBrainsMono Nerd Font"
                  font.pixelSize: 12
                  font.bold: modelData.id === root.activeWsId
                }
                MouseArea {
                  anchors.fill: parent
                  onClicked: {
                    pWsAction.command = ["niri", "msg", "action", "focus-workspace", (modelData.idx + 1).toString()]
                    pWsAction.running = true
                  }
                }
              }
            }

            Text {
              visible: root.media !== ""
              text: root.media !== "" ? " \u25B6 " + root.media : ""
              color: root.cMauve
              font.family: "JetBrainsMono Nerd Font"
              font.pixelSize: 12
              elide: Text.ElideRight
              Layout.maximumWidth: 220
            }
          }

          Item { Layout.fillWidth: true }

          // Centre: clock
          Text {
            id: clockText
            property var now: new Date()
            text: Qt.formatTime(now, "hh:mm")
            color: root.cText
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 13
            font.bold: true
            Timer {
              interval: 10000; running: true; repeat: true
              onTriggered: clockText.now = new Date()
            }
          }

          Item { Layout.fillWidth: true }

          // Right: system tray + volume + battery
          RowLayout {
            spacing: 8

            Repeater {
              model: SystemTray.items
              delegate: Item {
                required property SystemTrayItem modelData
                implicitWidth: 16; implicitHeight: 16
                Image { anchors.fill: parent; source: modelData.icon }
                MouseArea {
                  anchors.fill: parent
                  acceptedButtons: Qt.LeftButton | Qt.RightButton
                  onClicked: mouse => {
                    if (mouse.button === Qt.LeftButton) modelData.activate()
                    else modelData.secondaryActivate()
                  }
                }
              }
            }

            // Volume
            RowLayout {
              spacing: 4
              Text {
                text: root.muted ? "\uDB81\uDD3F" : root.volume > 66 ? "\uDB81\uDD7E" : root.volume > 33 ? "\uDB80\uDD80" : "\uDB80\uDD7F"
                color: root.cTeal
                font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 14
              }
              Text {
                text: root.muted ? "muted" : root.volume + "%"
                color: root.muted ? root.cOverlay0 : root.cText
                font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12
              }
            }

            // Battery
            RowLayout {
              spacing: 4
              Text {
                text: root.charging ? "\uF0E7" :
                      root.battery > 90 ? "\uF240" :
                      root.battery > 70 ? "\uF241" :
                      root.battery > 50 ? "\uF242" :
                      root.battery > 30 ? "\uF243" :
                      root.battery > 10 ? "\uF244" : "\uF244"
                color: root.charging ? root.cGreen : root.battery > 20 ? root.cYellow : root.cRed
                font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 14
              }
              Text {
                text: root.battery + "%"
                color: root.charging ? root.cGreen : root.battery > 20 ? root.cText : root.cRed
                font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 12
              }
            }
          }
        }
      }
    }
  '';

  # Gammastep for night light
  services.gammastep = {
    enable = true;
    dawnTime = "08:00";
    duskTime = "22:00";
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
      background-color = "#1e1e2e";
      text-color = "#cdd6f4";
      border-color = "#cba6f7";
      border-radius = 8;
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
      color = "1e1e2e";
      bs-hl-color = "f38ba8";
      caps-lock-bs-hl-color = "f38ba8";
      caps-lock-key-hl-color = "94e2d5";
      inside-color = "00000000";
      inside-clear-color = "00000000";
      inside-caps-lock-color = "00000000";
      inside-ver-color = "00000000";
      inside-wrong-color = "00000000";
      key-hl-color = "cba6f7";
      layout-bg-color = "00000000";
      layout-border-color = "00000000";
      layout-text-color = "cdd6f4";
      line-color = "00000000";
      line-clear-color = "00000000";
      line-caps-lock-color = "00000000";
      line-ver-color = "00000000";
      line-wrong-color = "00000000";
      ring-color = "313244";
      ring-clear-color = "94e2d5";
      ring-caps-lock-color = "f9e2af";
      ring-ver-color = "cba6f7";
      ring-wrong-color = "f38ba8";
      separator-color = "00000000";
      text-color = "cdd6f4";
      text-clear-color = "94e2d5";
      text-caps-lock-color = "f9e2af";
      text-ver-color = "cba6f7";
      text-wrong-color = "f38ba8";

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
      background-color: #1e1e2e;
      border: 2px solid #cba6f7;
      border-radius: 12px;
      color: #cdd6f4;
      font-family: "JetBrainsMono Nerd Font", monospace;
      font-size: 14px;
    }

    #input {
      margin: 8px;
      border: none;
      border-bottom: 2px solid #cba6f7;
      color: #cdd6f4;
      background-color: #181825;
      padding: 8px;
      border-radius: 6px 6px 0 0;
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
      color: #cdd6f4;
    }

    #entry {
      padding: 4px;
      border-radius: 6px;
    }

    #entry:selected {
      background-color: #cba6f7;
      color: #1e1e2e;
      border-radius: 6px;
    }

    #entry:selected #text {
      color: #1e1e2e;
    }

    #img {
      margin-right: 8px;
    }
  '';

  xdg.configFile."mako/config".force = true;
  xdg.configFile."wofi/config".force = true;
  xdg.configFile."wofi/style.css".force = true;

  # Yazi file manager with Catppuccin Mocha
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
          fg = "#94e2d5";
        };
        hovered = {
          fg = "#1e1e2e";
          bg = "#cba6f7";
        };
        preview_hovered = {
          underline = true;
        };
        find_keyword = {
          fg = "#f9e2af";
          bold = true;
        };
        find_position = {
          fg = "#eba0ac";
          bg = "reset";
          bold = true;
        };
        marker_copied = {
          fg = "#94e2d5";
          bg = "#94e2d5";
        };
        marker_cut = {
          fg = "#f38ba8";
          bg = "#f38ba8";
        };
        marker_selected = {
          fg = "#cba6f7";
          bg = "#cba6f7";
        };
        tab_active = {
          fg = "#1e1e2e";
          bg = "#cba6f7";
        };
        tab_inactive = {
          fg = "#cdd6f4";
          bg = "#181825";
        };
        tab_width = 1;
        border_symbol = "│";
        border_style = {
          fg = "#313244";
        };
        count_copied = {
          fg = "#1e1e2e";
          bg = "#94e2d5";
        };
        count_cut = {
          fg = "#1e1e2e";
          bg = "#f38ba8";
        };
        count_selected = {
          fg = "#1e1e2e";
          bg = "#cba6f7";
        };
      };
      status = {
        separator_open = "";
        separator_close = "";
        separator_style = {
          fg = "#181825";
          bg = "#181825";
        };
        mode_normal = {
          fg = "#1e1e2e";
          bg = "#cba6f7";
          bold = true;
        };
        mode_select = {
          fg = "#1e1e2e";
          bg = "#94e2d5";
          bold = true;
        };
        mode_unset = {
          fg = "#1e1e2e";
          bg = "#f38ba8";
          bold = true;
        };
        progress_label = {
          fg = "#cdd6f4";
          bold = true;
        };
        progress_normal = {
          fg = "#313244";
          bg = "#181825";
        };
        progress_error = {
          fg = "#f38ba8";
          bg = "#181825";
        };
        permissions_t = {
          fg = "#94e2d5";
        };
        permissions_r = {
          fg = "#f9e2af";
        };
        permissions_w = {
          fg = "#f38ba8";
        };
        permissions_x = {
          fg = "#a6e3a1";
        };
        permissions_s = {
          fg = "#6c7086";
        };
      };
      input = {
        border = {
          fg = "#cba6f7";
        };
        title = { };
        value = { };
        selected = {
          reversed = true;
        };
      };
      select = {
        border = {
          fg = "#cba6f7";
        };
        active = {
          fg = "#eba0ac";
        };
        inactive = { };
      };
      tasks = {
        border = {
          fg = "#cba6f7";
        };
        title = { };
        hovered = {
          underline = true;
        };
      };
      which = {
        mask = {
          bg = "#181825";
        };
        cand = {
          fg = "#94e2d5";
        };
        rest = {
          fg = "#6c7086";
        };
        desc = {
          fg = "#eba0ac";
        };
        separator = "  ";
        separator_style = {
          fg = "#313244";
        };
      };
      help = {
        on = {
          fg = "#eba0ac";
        };
        run = {
          fg = "#94e2d5";
        };
        desc = {
          fg = "#6c7086";
        };
        hovered = {
          bg = "#313244";
          bold = true;
        };
        footer = {
          fg = "#cdd6f4";
          bg = "#181825";
        };
      };
      filetype = {
        rules = [
          {
            mime = "image/*";
            fg = "#94e2d5";
          }
          {
            mime = "video/*";
            fg = "#f9e2af";
          }
          {
            mime = "audio/*";
            fg = "#f9e2af";
          }
          {
            mime = "application/zip";
            fg = "#eba0ac";
          }
          {
            mime = "application/gzip";
            fg = "#eba0ac";
          }
          {
            mime = "application/x-tar";
            fg = "#eba0ac";
          }
          {
            mime = "application/x-bzip";
            fg = "#eba0ac";
          }
          {
            mime = "application/x-bzip2";
            fg = "#eba0ac";
          }
          {
            mime = "application/x-7z-compressed";
            fg = "#eba0ac";
          }
          {
            mime = "application/x-rar";
            fg = "#eba0ac";
          }
          {
            name = "*";
            fg = "#cdd6f4";
          }
          {
            name = "*/";
            fg = "#cba6f7";
          }
        ];
      };
    };
  };

  # Zathura document viewer with Catppuccin Mocha
  programs.zathura = {
    enable = true;
    options = {
      default-bg = "#1e1e2e";
      default-fg = "#cdd6f4";
      statusbar-bg = "#181825";
      statusbar-fg = "#cdd6f4";
      inputbar-bg = "#181825";
      inputbar-fg = "#cdd6f4";
      notification-bg = "#181825";
      notification-fg = "#cdd6f4";
      notification-error-bg = "#181825";
      notification-error-fg = "#f38ba8";
      notification-warning-bg = "#181825";
      notification-warning-fg = "#f9e2af";
      highlight-color = "#f9e2af";
      highlight-active-color = "#cba6f7";
      completion-bg = "#181825";
      completion-fg = "#cdd6f4";
      completion-highlight-bg = "#313244";
      completion-highlight-fg = "#cdd6f4";
      recolor = true;
      recolor-lightcolor = "#1e1e2e";
      recolor-darkcolor = "#cdd6f4";
      recolor-keephue = true;
    };
  };

}
