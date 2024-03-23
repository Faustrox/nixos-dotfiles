{ config, lib, pkgs, ... }:

{

  options = {
    wlogout.setup = lib.mkEnableOption "Enable and configure wlogout";
  };

  config = lib.mkIf config.wlogout.setup {

    programs.wlogout = {
      enable = true;
      layout = [
        {
          label = "logout";
          action = "hyprctl dispatch exit 0";
          text = "";
          keybind = "l";
        }
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "";
          keybind = "s";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "";
          keybind = "r";
        }
      ];
    };

    home.file = {
      ".config/wlogout/icons".source = ../config/wlogout/icons;
      ".config/wlogout/style.css".source = ../config/wlogout/style.css;
    };

  };

}