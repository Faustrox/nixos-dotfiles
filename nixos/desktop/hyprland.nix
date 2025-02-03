{ config, pkgs, lib, inputs, ... }:
let
  hyprPackages = inputs.hyprland.packages.${pkgs.system};
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

    programs = {
      uwsm.enable = true;
      ssh.startAgent = true;
      hyprland = {
        enable = true;
        withUWSM  = true;
        xwayland.enable = true;
        portalPackage = hyprPackages.xdg-desktop-portal-hyprland;
        package = hyprPackages.hyprland;
      };
    };

    services = {
      gnome.gnome-keyring.enable = true;
      gvfs.enable = true;
    };
    security.pam.services.gdm.enableGnomeKeyring = true;

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

    environment.sessionVariables = {
      NIXOS_OZONE_WL = 1;
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      MOZ_ENABLE_WAYLAND = 1;
      MOZ_DBUS_REMOTE = 1;

      GDK_BACKEND = "wayland";
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      
      QT_AUTO_SCREEN_SCALE_FACTOR = 1;
      QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;

      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";
    };
    
  };

}
