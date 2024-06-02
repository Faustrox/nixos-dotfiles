{ config, lib, ... }:

{

  options = {
    waybar.setup =
      lib.mkEnableOption "Enables and configure Waybar";
  };

  config = lib.mkIf config.waybar.setup {

    programs.waybar.enable = true;

    home.file = {
      ".config/waybar/config".source = ../config/waybar/config;
      ".config/waybar/style.css".source = ../config/waybar/style.css;
      ".config/waybar/mocha.css".source = ../config/waybar/mocha.css;
    };

  };

}
