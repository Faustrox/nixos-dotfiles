{ config, lib, pkgs, ... }:

{

  options = {
    portals.enable = 
      lib.mkEnableOption "Enable and configure XDG Portals";
    portals.extraPortals = 
      lib.mkOption {
        default = [];
        description = ''
          Extra portals to set up
        '';
      };
  };

  config = lib.mkIf config.portals.enable {
      # setting up portals
      xdg.portal = {
        enable = true;
        extraPortals = config.portals.extraPortals;
        xdgOpenUsePortal = true;
      };
    };

}