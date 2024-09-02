{ config, pkgs, lib, inputs, ... }: 

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
      package = inputs.hyprland.packages.x86_64-linux.hyprland;
    };

    overlays.hyprland-portal.fix = true;

    services = {
      displayManager = { 
        sddm = {
          enable = true;
          package = pkgs.kdePackages.sddm;
          wayland.enable = true;
          catppuccin.enable = true;
        };
      };
      gvfs.enable = true;
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
      SDL_VIDEODRIVER = "wayland,x11";
      CLUTTER_BACKEND = "wayland";
      XDG_SESSION_TYPE = "wayland";
    };

  };

}
