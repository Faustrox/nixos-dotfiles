{ config, lib, pkgs, ... }:

{

  options = {
    hyprland.setup =
      lib.mkEnableOption "Enables and configure Hyprland";
  };

  config = lib.mkIf config.hyprland.setup {

    home.packages = with pkgs; [

      cliphist
      grim
      slurp
      gnome.nautilus
      libnotify
      swww
      wofi
      hyprpicker

    ];

    dunst.setup = true;
    waybar.setup = true;
    wofi.setup = true;

    home.file = {

      # Configs
      ".config/hypr".source = ../config/hypr;

    };

  };

}
