{ config, lib, pkgs, ... }:

{

  options = {
    hyprland.setup =
      lib.mkEnableOption "Enables and configure Hyprland";
  };

  config = lib.mkIf config.hyprland.setup {

    wayland.windowManager.hyprland = {
      
      enable = true;
      systemd.variables = ["--all"];
      settings = {
        
        autogenerated = 0;
        source = [
          "$HOME/.config/hypr/config/autostart.conf"
          "$HOME/.config/hypr/config/keybindings.conf"
          "$HOME/.config/hypr/config/rules.conf"
          "$HOME/.config/hypr/themes/mocha.conf"
        ];
        monitor = [
          "DP-1,2560x1440@165, 1920x0, 1"
          "DP-2,1920x1080@144, 0x360, 1"
        ];
        exec-once = "xrandr --output DP-1 --primary";

        #####################
        ### LOOK AND FEEL ###
        #####################

        # Refer to https://wiki.hyprland.org/Configuring/Variables/

        # https://wiki.hyprland.org/Configuring/Variables/#general
        general = { 

          gaps_in = 10;
          gaps_out = 20;

          border_size = 3;
          "col.active_border" = "$mauve $sapphire 45deg";
          "col.inactive_border" = "$overlay0";
          # Set to true enable resizing windows by clicking and dragging on borders and gaps
          resize_on_border = false;
          allow_tearing = true;
          layout = "dwindle";

        };

        decoration = {

          rounding = 15;
          # Change transparency of focused and unfocused windows
          active_opacity = 1.0;
          inactive_opacity = 1.0;
          drop_shadow = true;
          shadow_range = "15";
          shadow_render_power = 3;
          "col.shadow" = "$surface0";

          blur = {

            enabled = true;
            size = 9;
            passes = 4;
            new_optimizations = true;
            vibrancy = 0.1696;

          };
        };

        animations = {

          enabled = true;

          bezier = [
            "myBezier, 0.05, 0.9, 0.1, 1.05"
            "myBezier2, 0.65, 0, 0.35, 1"
            "slow,0,0.85,0.3,1"
            "overshot,0.7,0.6,0.1,1.1"
            "bounce,1,1.6,0.1,0.85"
            "slingshot,1,-1,0.15,1.25"
            "nice,0,6.9,0.5,-4.20"
          ];
          animation = [
            "windows,1,5,bounce,popin"
            "border,1,20,default"
            "fade,1,5,default"
            "workspaces,1,5,overshot,slide"
          ];

        };

        dwindle = {

          pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true; # You probably want this

        };

        #############
        ### INPUT ###
        #############

        input = {

          kb_layout = "us";
          kb_variant = "intl";
          kb_model = "";
          kb_options = "";
          kb_rules = "";

          mouse_refocus = false;
          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
          accel_profile = "flat";
        
        };

        ##############
        ### OTHERS ###
        ##############

        misc = { 

            force_default_wallpaper = 0; # Set to 0 or 1 to disable the anime mascot wallpapers
            disable_hyprland_logo = true; # If true disables the random hyprland logo / anime girl background. :(
            animate_manual_resizes = true;

        };

        render = {

            explicit_sync = 1;
            explicit_sync_kms = 0;
            direct_scanout = true;
        
        };

        opengl = {

          nvidia_anti_flicker = true;
          force_introspection = 1;

        };

      };
    };

    home = {

      sessionVariables = {
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_DESKTOP = "Hyprland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
      };

      packages = with pkgs; [

        # Multimedia
        cliphist
        playerctl

        # System Apps
        nautilus
        gnome-system-monitor
        gparted
        waypaper
        grim
        slurp
        libnotify
        swww
        wofi
        hyprpicker
        ags

      ];

      file = {

        ".config/hypr/config".source = ../config/hypr/config;
        ".config/hypr/themes".source = ../config/hypr/themes;
        ".config/hypr/scripts".source = ../config/hypr/scripts;

      };

    };

    # Hide GTK Window Title Buttons
    dconf.settings."org/gnome/desktop/wm/preferences".button-layout = "";

    dunst.setup = true;
    waybar.setup = true;
    wofi.setup = true;

    xdg = {
      mimeApps = {
        enable = true;
        defaultApplications = {
          "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
        };
        associations.removed = {
          "inode/directory" = "code.desktop";
        };
      };
    };
    
  };

}
