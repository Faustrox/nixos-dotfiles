{ config, lib, pkgs, ... }:

{

  options = {
    plasma.enable = 
      lib.mkEnableOption "Enable and configure Plasma";
    plasma.forceX11 =
      lib.mkEnableOption "Force X11 to plasma";
  };

  config = lib.mkMerge [
      (lib.mkIf config.plasma.enable {
        # Enable the Plasma 6 Dekstop Environment.
        services.xserver.displayManager.sddm.enable = true;
        services.xserver.displayManager.sddm.wayland.enable = if config.plasma.forceX11 then false else true;

        services.desktopManager.plasma6.enable = true;
        services.xserver.displayManager.defaultSession = if config.plasma.forceX11 then "plasmax11" else "plasma";

        # Set up KDE Wallet 
        security.pam.services.kwallet = {
          name = "kwallet";
          enableKwallet = true;
        };

        # setting up portals
        xdg.portal = {
          enable = true;
          extraPortals = with pkgs; [
            xdg-desktop-portal-gtk
            kdePackages.xdg-desktop-portal-kde
          ];
        };
      }
    )
    (lib.mkIf (!config.plasma.forceX11) {
        environment.sessionVariables = {
          NIXOS_OZONE_WL = "1";
          WLR_RENDERER = "vulkan";
        };
      }
    )
  ];

}