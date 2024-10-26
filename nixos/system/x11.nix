{ config, lib, pkgs, ... }:

{
  
  options = {
    x11 = {
      enable =
        lib.mkEnableOption "Enables and configure X11";
      keymap = 
        lib.mkOption {
          description = "Keymap";
      };
    };
  };

  config = lib.mkIf config.x11.enable {
    

    services.xserver = {
      # Enable the X11 windowing system.
      enable = config.x11.enable;
      # Configure keymap in X11
      xkb.layout = config.x11.keymap.layout;
      xkb.variant =  config.x11.keymap.variant;
      xkb.model = "pc105";
      xkb.options = "terminate:ctrl_alt_bksp";
      # Remove Xterm
      excludePackages = [ pkgs.xterm ];
      desktopManager.xterm.enable = false;
    };


  };

}
