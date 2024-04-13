{ config, lib, pkgs, ... }:

{
  
  options = {
    x11.enable =
      lib.mkEnableOption "Enables and configure X11";
  };

  config = lib.mkIf config.x11.enable {
    
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Remove Xterm
    services.xserver.excludePackages = [ pkgs.xterm ];
    services.xserver.desktopManager.xterm.enable = false;

  };

}
