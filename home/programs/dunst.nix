{ config, lib, pkgs, ... }:

{
  
  options = {
    dunst.setup = 
      lib.mkEnableOption "Enables and configure dunst";
  };

  config = lib.mkIf config.dunst.setup {

    services.dunst = {
      enable = true;
      catppuccin.enable = true;
    };

  };

}