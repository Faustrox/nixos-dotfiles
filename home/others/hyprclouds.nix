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
      # gtk3
      socat
      ripgrep
      pulseaudio

      (pkgs.writers.writeBashBin "ags-start" ''
        ${pkgs.procps}/bin/pkill gjs
        while ${pkgs.procps}/bin/pgrep gjs >/dev/null; do ${pkgs.coreutils}/bin/sleep 0.1; done
        ${pkgs.app2unit}/bin/app2unit -s s -- ags run --gtk 4 &
      '')

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
          inputs.ags.packages.${pkgs.system}.network
          inputs.ags.packages.${pkgs.system}.bluetooth
          inputs.ags.packages.${pkgs.system}.apps
        ];
      };
      wofi.enable = false;
    };

  };

}
