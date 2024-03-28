{ config, lib, ... }:

{

  options = {
    plasma.enable = 
      lib.mkEnableOption "enables plasma wayland";
  };

  config = lib.mkIf config.plasma.enable {
    # Enable the Plasma 6 Dekstop Environment.
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.displayManager.sddm.wayland.enable = true;

    services.desktopManager.plasma6.enable = true;
    services.xserver.displayManager.defaultSession = "plasma";

    # Set up KDE Wallet 
    security.pam.services.kwallet = {
      name = "kwallet";
      enableKwallet = true;
    };
  };

}