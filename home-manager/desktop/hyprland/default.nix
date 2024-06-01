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

    ];

    home.file = {

      # Configs
      ".config/hypr/config/autostart.conf".source = ./config/autostart.conf;
      ".config/hypr/config/keybindings.conf".source = ./config/keybindings.conf;
      ".config/hypr/config/nvidia.conf".source = ./config/nvidia.conf;
      ".config/hypr/config/rules.conf".source = ./config/rules.conf;
      
      # Themes
      ".config/hypr/themes/mocha.conf".source = ./themes/mocha.conf;

      # Main config file
      ".config/hypr/hyprland.conf".source = ./config/hyprland.conf;

    };

  };

}
