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
      gnome.gnome-system-monitor
      libnotify
      swww
      waypaper
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

    xdg = {
      enable = true;
      mimeApps = {
        enable = true;
        defaultApplications = {
          "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
        };
        associations.removed = {
          "inode/directory" = "code.desktop";
        };
      };
    };
    
  };

}
