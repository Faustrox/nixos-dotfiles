{ config, lib, pkgs, ... }:

{
  
  options = {
    xserver = {
      enable =
        lib.mkEnableOption "Enables and configure xserver";
      keymap = 
        lib.mkOption {
          description = "Keymap";
      };
    };
  };

  config = lib.mkIf config.xserver.enable {
    

    services.xserver = {
      # Enable the X11 windowing system.
      enable = config.xserver.enable;
      # Configure keymap in X11
      xkb.layout = config.xserver.keymap.layout;
      xkb.variant =  config.xserver.keymap.variant;
      xkb.model = "pc105";
      xkb.options = "terminate:ctrl_alt_bksp";
      # Remove Xterm
      excludePackages = [ pkgs.xterm ];
      desktopManager.xterm.enable = false;
      displayManager.lightdm.enable = false;
    };


  };

}
