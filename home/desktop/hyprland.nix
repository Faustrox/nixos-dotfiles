{ config, lib, pkgs, ... }:

{

  options = {
    hyprland.setup =
      lib.mkEnableOption "Enables and configure Hyprland";
  };

  config = lib.mkIf config.hyprland.setup {

    home.packages = with pkgs; [

      copyq
      cliphist
      grim
      slurp
      gnome.nautilus
      dunst
      libnotify
      swww
      rofi-wayland
      waybar

    ];

    waybar.setup = true;

    home.file = {

      # Configs
      ".config/hypr/config/autostart.conf".source = ../config/hypr/config/autostart.conf;
      ".config/hypr/config/keybindings.conf".source = ../config/hypr/config/keybindings.conf;
      ".config/hypr/config/nvidia.conf".source = ../config/hypr/config/nvidia.conf;
      ".config/hypr/config/rules.conf".source = ../config/hypr/config/rules.conf;
      
      # Themes
      ".config/hypr/themes/mocha.conf".source = ../config/hypr/themes/mocha.conf;

      # Main config file
      ".config/hypr/hyprland.conf".source = ../config/hypr/hyprland.conf;

    };

  };

}
