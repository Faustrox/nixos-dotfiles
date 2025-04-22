{ config, lib, pkgs, inputs, ... }:

{

  options = {
    hyprclouds.enable = 
      lib.mkEnableOption "Enable hyprclouds for nix.";
  };

  config = lib.mkIf config.hyprclouds.enable {

    home.packages = with pkgs; [
      # matugen
      # rofi
      gtk3
      socat
      ripgrep
      pulseaudio
    ];

    programs = {
      ags = {
        enable = true;

        configDir = ../config/ags;

        extraPackages = with pkgs; [
          bun
          gtksourceview
          # webkitgtk
          accountsservice
          inputs.ags.packages.${pkgs.system}.hyprland
          inputs.ags.packages.${pkgs.system}.notifd
          inputs.ags.packages.${pkgs.system}.tray
          inputs.ags.packages.${pkgs.system}.wireplumber
          inputs.ags.packages.${pkgs.system}.apps
        ];
      };
      wofi.enable = false;
    };
    
    home = {
      shellAliases = {
        ags-start = "uwsm app -s b -- $HOME/.scripts/start.sh";
      };

      file = {
        ".scripts/start.sh".source = ./scripts/ags-start.sh;
      };
    };

  };

}
