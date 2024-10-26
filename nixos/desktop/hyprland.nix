{ config, pkgs, lib, inputs, ... }:
let
  hyprland.packages = inputs.hyprland.packages.x86_64-linux;
in
{

  options = {
    hyprland.enable = 
      lib.mkEnableOption "Enable Hyprland and configure";
  };

  config = lib.mkIf config.hyprland.enable {

    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    programs.hyprland = {
      enable = true;
      package = hyprland.packages.hyprland;
    };

    services = {
      gvfs.enable = true;

      displayManager = {
        sddm = {
          enable = true;
          package = pkgs.kdePackages.sddm;
          wayland.enable = true;
          catppuccin.enable = true;
        };
      };

      # Sets primary display on xwayland
      xserver.displayManager.setupCommands = ''
        ${pkgs.xorg.xrandr}/bin/xrandr --output DP-1 --primary
      '';  
    };

    
    systemd = {
      user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
      };
    };

    xdg.mime = {
      enable = true;
      defaultApplications = {
        "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
      };
      removedAssociations = {
        "inode/directory" = "code.desktop";
      };
    };

    # Xwayland VRAM usage fix on Nvidia GPU
    environment.etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-hyprland.txt".text = ''
      {
        "rules": [
          {
            "pattern": {
              "feature": "procname",
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

    environment.systemPackages = with pkgs; [
      
      wlr-randr
      wl-clipboard
      wl-clip-persist
      networkmanagerapplet
      polkit_gnome
      zenity
      
    ];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      MOZ_ENABLE_WAYLAND = "1";

      GDK_BACKEND = "wayland,x11,*";
      QT_QPA_PLATFORM = "wayland;xcb";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";
      QT_AUTO_SCREEN_SCALE_FACTOR = 1;
      QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
    };
    
  };

}
