{ config, pkgs, lib, inputs, ... }: 

{

  options = {
    plasma.enable = 
      lib.mkEnableOption "Enable KDE Plasma and configure";
  };

  config = lib.mkIf config.plasma.enable {

    services = {
      desktopManager.plasma6.enable = true;

      displayManager = {
        sddm = {
          enable = true;
          wayland.enable = true;
        };
        autoLogin = {
          enable = true;
          user = config.main-user.username;
        };
      };
    };

    programs.kdeconnect.enable = true;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = 1;
      # ELECTRON_OZONE_PLATFORM_HINT = "auto";
      MOZ_ENABLE_WAYLAND = 1;
      MOZ_DBUS_REMOTE = 1;

      GDK_BACKEND = "wayland,x11,*";
      QT_QPA_PLATFORM = "wayland;xcb";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
    };

  };

}
