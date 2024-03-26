{ config, pkgs, ... }:

{

  # Enable the Plasma 6 Dekstop Environment.
  services.xserver.displayManager.sddm.enable = true;
  # services.xserver.displayManager.sddm.wayland.enable = true;

  services.desktopManager.plasma6.enable = true;
  # plasma for wayland and plasmax11 for X11
  services.xserver.displayManager.defaultSession = "plasmax11";

  # Set up KDE Wallet 
  security.pam.services.kwallet = {
    name = "kwallet";
    enableKwallet = true;
  };


}