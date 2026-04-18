{
  config,
  pkgs,
  lib,
  username,
  ...
}:

# Catppuccin Mocha colors:
# base:      #1e1e2e  mantle:  #181825  crust:    #11111b
# surface0:  #313244  surface1:#45475a  surface2: #585b70
# overlay0:  #6c7086  overlay1:#7f849c  overlay2: #9399b2
# text:      #cdd6f4  mauve:   #cba6f7  red:      #f38ba8
# yellow:    #f9e2af  green:   #a6e3a1  teal:     #94e2d5
# blue:      #89b4fa  lavender:#b4befe

let
  # Shortcuts for Hyprland rgba() color format
  base     = "1e1e2e";
  mantle   = "181825";
  surface0 = "313244";
  overlay0 = "6c7086";
  text     = "cdd6f4";
  subtext1 = "bac2de";
  mauve    = "cba6f7";
  red      = "f38ba8";
  maroon   = "eba0ac";
  yellow   = "f9e2af";
  green    = "a6e3a1";
  teal     = "94e2d5";

  rz = c: "rgba(${c}ff)";
in

{
  # --- Cursor ---
  home.pointerCursor = {
    gtk.enable = true;
    name = "catppuccin-mocha-mauve-cursors";
    package = pkgs.catppuccin-cursors.mochaMauve;
    size = 24;
  };

  dconf.enable = true;

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

  # --- GTK ---
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
    gtk3.extraConfig.gtk-decoration-layout = "";
    gtk4 = {
      extraConfig.gtk-decoration-layout = "";
      theme = null;  # let caelestia manage gtk.css for gtk4
    };
  };

  # --- Hyprland ---
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = ",highrr,auto,1";

      exec-once = [
        "swww-daemon"
        "waybar"
        "nm-applet --indicator"
        "wl-paste --watch cliphist store"
      ];

      env = [
        "XCURSOR_THEME,catppuccin-mocha-mauve-cursors"
        "XCURSOR_SIZE,24"
      ];

      general = {
        gaps_in = 6;
        gaps_out = 12;
        border_size = 2;
        "col.active_border" = rz mauve;
        "col.inactive_border" = rz surface0;
        layout = "dwindle";
        resize_on_border = true;
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 8;
          passes = 2;
        };
        shadow = {
          enabled = false;
        };
      };

      animations = {
        enabled = true;
        bezier = "easeOut, 0.33, 1, 0.68, 1";
        animation = [
          "windows, 1, 4, easeOut, popin 80%"
          "windowsOut, 1, 4, easeOut, popin 80%"
          "border, 1, 6, default"
          "fade, 1, 4, default"
          "workspaces, 1, 4, easeOut, slide"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      input = {
        kb_layout = "gb";
        touchpad = {
          natural_scroll = true;
          scroll_factor = 0.5;
        };
        sensitivity = 0.2;
        follow_mouse = 1;
      };

      device = [{
        name = "wacom-co.-ltd.-ctl-472-mouse";
        enabled = false;
      }];

misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      windowrule = [
        "match:class org\\.gnome\\..*, float on"
        "match:class nautilus, float on"
        "match:class nm-connection-editor, float on"
        "match:class blueman-manager, float on"
        "match:class yazi, float on, size 1200 700"
        "match:class wiki-nvim, float on, size 1400 900"
      ];

      "$mod" = "SUPER";

      bind = [
        # Apps
        "$mod, Return, exec, alacritty"
        "$mod, D, exec, wofi --show drun"
        "$mod, B, exec, zen"
        "$mod, Y, exec, alacritty --class yazi -e yazi"
        "$mod, W, exec, alacritty --class wiki-nvim --working-directory /home/${username}/wiki/ -e codium"
        "$mod SHIFT, W, exec, alacritty --working-directory /home/${username}/wiki/ -e opencode --agent wiki"

        # Window management
        "$mod, Q, killactive"
        "$mod SHIFT, Q, killactive"
        "$mod, F, fullscreen, 1"
        "$mod SHIFT, F, fullscreen, 0"
        "$mod, Space, togglefloating"

        # Session
        "$mod, Escape, exec, hyprlock"
        "$mod SHIFT, E, exec, wlogout"
        "$mod, Tab, workspace, +1"
        "$mod SHIFT, Tab, workspace, -1"

        # Clipboard
        "$mod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"

        # Screenshots
        ", Print, exec, grim -g \"$(slurp)\" - | satty -f -"
        "CTRL, Print, exec, grim - | satty -f -"
        "$mod, Print, exec, grim -g \"$(slurp)\" - | swappy -f -"

        # Vim-style focus
        "$mod, H, movefocus, l"
        "$mod, J, movefocus, d"
        "$mod, K, movefocus, u"
        "$mod, L, movefocus, r"
        "$mod, left, movefocus, l"
        "$mod, down, movefocus, d"
        "$mod, up, movefocus, u"
        "$mod, right, movefocus, r"

        # Move windows
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, J, movewindow, d"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, L, movewindow, r"
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, down, movewindow, d"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, right, movewindow, r"
      ] ++ (builtins.concatLists (builtins.genList (i:
        let ws = toString (i + 1); in [
          "$mod, ${ws}, workspace, ${ws}"
          "$mod SHIFT, ${ws}, movetoworkspace, ${ws}"
        ]
      ) 9));

      # Mouse window management
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Repeatable + works on lockscreen
      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];

      # Works on lockscreen
      bindl = [
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
    };
  };

  # --- Hyprlock (screen lock) ---
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
      };

      background = [{
        monitor = "";
        path = "screenshot";
        blur_passes = 2;
        blur_size = 8;
        color = rz base;
      }];

      input-field = [{
        monitor = "";
        size = "250, 50";
        outline_thickness = 2;
        outer_color = rz mauve;
        inner_color = rz surface0;
        font_color = rz text;
        fade_on_empty = true;
        placeholder_text = "Password";
        check_color = rz mauve;
        fail_color = rz red;
        capslock_color = rz yellow;
        position = "0, -120";
        halign = "center";
        valign = "center";
      }];

      label = [
        {
          monitor = "";
          text = "$TIME";
          color = rz text;
          font_size = 72;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:60000] date '+%A, %d %B'";
          color = rz subtext1;
          font_size = 20;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 0";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  # --- Waybar ---
  programs.waybar = {
    enable = true;
    settings = [{
      layer = "top";
      position = "top";
      margin-top = 8;
      margin-left = 12;
      margin-right = 12;
      height = 36;
      spacing = 4;

      modules-left = [ "hyprland/workspaces" "hyprland/window" ];
      modules-center = [ "clock" ];
      modules-right = [ "pulseaudio" "network" "cpu" "memory" "tray" ];

      "hyprland/workspaces" = {
        format = "{id}";
        on-scroll-up = "hyprctl dispatch workspace +1";
        on-scroll-down = "hyprctl dispatch workspace -1";
      };

      "hyprland/window" = {
        max-length = 60;
        separate-outputs = true;
      };

      clock = {
        format = "  {:%H:%M}";
        format-alt = "  {:%a %d %b}";
        tooltip-format = "<tt>{calendar}</tt>";
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = " muted";
        format-icons = { default = [ "" "" "" ]; };
        on-click = "pulsemixer";
      };

      network = {
        format-wifi = "  {essid}";
        format-ethernet = "  {ifname}";
        format-disconnected = " disconnected";
        tooltip-format = "{ipaddr}";
      };

      cpu = {
        format = " {usage}%";
        interval = 5;
      };

      memory = {
        format = " {percentage}%";
        interval = 5;
      };

      tray = {
        spacing = 8;
      };
    }];

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
        color: #cdd6f4;
      }

      .modules-left,
      .modules-center,
      .modules-right {
        background: #1e1e2e;
        border-radius: 12px;
        padding: 0 8px;
      }

      #workspaces button {
        padding: 0 8px;
        color: #6c7086;
        background: transparent;
        border-radius: 8px;
      }

      #workspaces button.active {
        color: #cba6f7;
        background: #313244;
      }

      #workspaces button:hover {
        color: #cdd6f4;
        background: #313244;
      }

      #window {
        color: #6c7086;
        padding: 0 8px;
      }

      #clock {
        color: #cdd6f4;
        padding: 0 12px;
        font-weight: bold;
      }

      #pulseaudio {
        color: #94e2d5;
        padding: 0 8px;
      }

      #pulseaudio.muted {
        color: #6c7086;
      }

      #network {
        color: #89b4fa;
        padding: 0 8px;
      }

      #network.disconnected {
        color: #f38ba8;
      }

      #cpu {
        color: #a6e3a1;
        padding: 0 8px;
      }

      #memory {
        color: #f9e2af;
        padding: 0 8px;
      }

      #tray {
        padding: 0 8px;
      }
    '';
  };

  # --- Screenshots directory ---
  home.file."Pictures/Screenshots/.keep".text = "";

  # --- Yazi file manager ---
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
        cwd = { fg = "#94e2d5"; };
        hovered = { fg = "#1e1e2e"; bg = "#cba6f7"; };
        preview_hovered = { underline = true; };
        find_keyword = { fg = "#f9e2af"; bold = true; };
        find_position = { fg = "#eba0ac"; bg = "reset"; bold = true; };
        marker_copied = { fg = "#94e2d5"; bg = "#94e2d5"; };
        marker_cut = { fg = "#f38ba8"; bg = "#f38ba8"; };
        marker_selected = { fg = "#cba6f7"; bg = "#cba6f7"; };
        tab_active = { fg = "#1e1e2e"; bg = "#cba6f7"; };
        tab_inactive = { fg = "#cdd6f4"; bg = "#181825"; };
        tab_width = 1;
        border_symbol = "│";
        border_style = { fg = "#313244"; };
        count_copied = { fg = "#1e1e2e"; bg = "#94e2d5"; };
        count_cut = { fg = "#1e1e2e"; bg = "#f38ba8"; };
        count_selected = { fg = "#1e1e2e"; bg = "#cba6f7"; };
      };
      status = {
        separator_open = "";
        separator_close = "";
        separator_style = { fg = "#181825"; bg = "#181825"; };
        mode_normal = { fg = "#1e1e2e"; bg = "#cba6f7"; bold = true; };
        mode_select = { fg = "#1e1e2e"; bg = "#94e2d5"; bold = true; };
        mode_unset = { fg = "#1e1e2e"; bg = "#f38ba8"; bold = true; };
        progress_label = { fg = "#cdd6f4"; bold = true; };
        progress_normal = { fg = "#313244"; bg = "#181825"; };
        progress_error = { fg = "#f38ba8"; bg = "#181825"; };
        permissions_t = { fg = "#94e2d5"; };
        permissions_r = { fg = "#f9e2af"; };
        permissions_w = { fg = "#f38ba8"; };
        permissions_x = { fg = "#a6e3a1"; };
        permissions_s = { fg = "#6c7086"; };
      };
      input = {
        border = { fg = "#cba6f7"; };
        title = { };
        value = { };
        selected = { reversed = true; };
      };
      select = {
        border = { fg = "#cba6f7"; };
        active = { fg = "#eba0ac"; };
        inactive = { };
      };
      tasks = {
        border = { fg = "#cba6f7"; };
        title = { };
        hovered = { underline = true; };
      };
      which = {
        mask = { bg = "#181825"; };
        cand = { fg = "#94e2d5"; };
        rest = { fg = "#6c7086"; };
        desc = { fg = "#eba0ac"; };
        separator = "  ";
        separator_style = { fg = "#313244"; };
      };
      help = {
        on = { fg = "#eba0ac"; };
        run = { fg = "#94e2d5"; };
        desc = { fg = "#6c7086"; };
        hovered = { bg = "#313244"; bold = true; };
        footer = { fg = "#cdd6f4"; bg = "#181825"; };
      };
      filetype.rules = [
        { mime = "image/*"; fg = "#94e2d5"; }
        { mime = "video/*"; fg = "#f9e2af"; }
        { mime = "audio/*"; fg = "#f9e2af"; }
        { mime = "application/zip"; fg = "#eba0ac"; }
        { mime = "application/gzip"; fg = "#eba0ac"; }
        { mime = "application/x-tar"; fg = "#eba0ac"; }
        { mime = "application/x-bzip"; fg = "#eba0ac"; }
        { mime = "application/x-bzip2"; fg = "#eba0ac"; }
        { mime = "application/x-7z-compressed"; fg = "#eba0ac"; }
        { mime = "application/x-rar"; fg = "#eba0ac"; }
        { name = "*"; fg = "#cdd6f4"; }
        { name = "*/"; fg = "#cba6f7"; }
      ];
    };
  };

  # --- Zathura document viewer ---
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
