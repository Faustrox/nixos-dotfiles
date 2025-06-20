{ config, pkgs, lib, inputs, ... }:
# let
#   hyprPackages = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
# in
{

  options = {
    hyprland.enable = 
      lib.mkEnableOption "Enable Hyprland and configure";
  };

  config = lib.mkIf config.hyprland.enable {

    programs = {
      uwsm.enable = true;
      # ssh.startAgent = true; # GnuPG need this disabled
      xwayland.enable = true;

      hyprland = {
        enable = true;
        withUWSM  = true;
        xwayland.enable = true;
        package = pkgs.hyprland;
        portalPackage = pkgs.xdg-desktop-portal-hyprland;
      };

      nautilus-open-any-terminal = {
        enable = true;
        terminal = "wezterm";
      };
    };

    services.greetd = let

      tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
      session = "${pkgs.uwsm}/bin/uwsm start hyprland-uwsm.desktop";
      username = config.main-user.username;

    in {
      enable = true;
      
      settings = {
        default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-session";
        initial_session = {
          command = "${session}";
          user = "${username}";
        };
      };
    };

    environment.systemPackages = with pkgs; [

      (pkgs.writers.writeBashBin "app2unit" ''
        ${builtins.readFile ./app2unit.sh}
      '')
      
      # Multimedia
      clipse
      playerctl
      feh

      # System Apps
      nautilus
      # gnome-system-monitor
      resources
      gparted
      waypaper
      grim
      slurp
      swww
      lz4 # For compressing frames when animating
      wofi
      hyprpicker
      # hyprpanel

      wlr-randr
      wl-clipboard
      wl-clip-persist
      zenity

      hyprland-workspaces
      hyprpolkitagent

      udiskie
    
    ];

    services.gvfs.enable = true;
    
    # Hyprland VRAM usage fix

    # boot.kernelParams = [
    #   "video=DP-1:D"
    #   "video=DP-2:D"
    # ];

    # VRAM usage fix on Nvidia GPU procname
    environment.etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool.json".text = ''
      {
        "rules": [
          {
            "pattern": {
              "feature": "cmdline",
              "matches": "Hyprland"
            },
            "profile": "Limit Free Buffer Pool On Hyprland"
          }
        ],
        "profiles": [
          {
            "name": "Limit Free Buffer Pool On Hyprland",
            "settings": [
              {
                "key": "GLVidHeapReuseRatio",
                "value": 1
              }
            ]
          }
        ]
      }
    '';

    environment.sessionVariables = {
      APP2UNIT_SLICES = "a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice";
      APP2UNIT_TYPE = "scope";

      NIXOS_OZONE_WL = 1;
      # ELECTRON_OZONE_PLATFORM_HINT = "auto";
      MOZ_ENABLE_WAYLAND = 1;
      MOZ_DBUS_REMOTE = 1;

      GDK_BACKEND = "wayland,x11,*";
      QT_QPA_PLATFORM = "wayland;xcb";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      
      QT_AUTO_SCREEN_SCALE_FACTOR = 1;
      QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;

      XDG_CURRENT_DESKTOP = "Hyprland";
      # XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";

      # Using dbus-broker, won't need VARS and NOTIFY
      HYPRLAND_NO_SD_VARS = 1;
      HYPRLAND_NO_SD_NOTIFY = 1;
      HYPRLAND_NO_RT = 1;

      # Nvidia Settings
      # AQ_NO_ATOMIC = 1;
      # AQ_NO_MODIFIERS = 1;
      # __GL_VRR_ALLOWED = 1;
      # __GL_GSYNC_ALLOWED = 1;
      # __GL_MaxFramesAllowed = 1;
    };
    
  };

}
