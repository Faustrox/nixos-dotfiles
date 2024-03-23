{ config, lib, ... }:

{

  options = {
    waybar.setup =
      lib.mkEnableOption "Enables and configure Waybar";
  };

  config = lib.mkIf config.waybar.setup {

    programs.waybar.enable = true;

    home.file = {
      ".config/waybar".source = ../config/waybar;
    };

  };

}
