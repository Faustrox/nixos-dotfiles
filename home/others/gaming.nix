{ lib, config, pkgs, inputs, ... }:

{

  options = {
    gaming.setup = 
      lib.mkEnableOption "Configure and install gaming packages";
    gaming.steamRoot = 
      lib.mkOption {
        default = "/mnt/games/Libreries/Steam";
        description = "Where steam libreary is located";
      };
  };

  config = lib.mkIf config.gaming.setup {

    home.packages = with pkgs;
    let
      suyu = inputs.suyu.packages.x86_64-linux;
    in [

      # Social
      discord

      # Emulators
      suyu.suyu

      # Launchers
      lutris
      prismlauncher
      heroic

      # Wine
      wineWowPackages.stableFull
      winetricks
      bottles

      # Utils
      wlx-overlay-s
      mangohud
      goverlay
      protonup-qt
      protonup-ng
      vkbasalt
      steamPackages.steamcmd

    ];

    programs = {
      java.enable = true;
    };

    home.sessionVariables = {
      STEAM_ROOT = config.gaming.steamRoot;
      __GL_SHADER_DISK_CACHE = "1";
      __GL_SHADER_DISK_CACHE_PATH = "/home/faustrox/.shaders";
      __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
      VKBASALT_CONFIG_FILE = "/mnt/games/Reshade/vkBasalt.conf";
      PROTON_HIDE_NVIDIA_GPU = "0";
      DXVK_HUD = "compiler";
      DXVK_ASYNC = "1";
      WEBKIT_DISABLE_COMPOSITING_MODE = "1"; # Fixes problems for logins in Lutris and other apps
    };

  };

}