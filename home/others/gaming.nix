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

      # VR
      alvr

      # Utils
      mangohud
      goverlay
      wineWowPackages.unstable
      winetricks
      protonup-qt
      protonup-ng
      protontricks
      vkbasalt
      steamPackages.steamcmd

    ];

    home.sessionVariables = {
      STEAM_ROOT = config.gaming.steamRoot;
      __GL_SHADER_DISK_CACHE = "1";
      __GL_SHADER_DISK_CACHE_PATH = "/home/faustrox/.shaders";
      __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
      VKBASALT_CONFIG_FILE = "/mnt/games/Reshade/vkBasalt.conf";
      PROTON_ENABLE_NVAPI = "1";
      PROTON_HIDE_NVIDIA_GPU = "0";
      DXVK_ENABLE_NVAPI = "1";
      DXVK_HUD = "compiler";
      DXVK_ASYNC = "1";
      VKD3D_CONFIG = "dxr";
      WEBKIT_DISABLE_COMPOSITING_MODE = "1"; # Fixes problems for logins in Lutris and other apps
      # PULSE_LATENCY_MSEC = "60";
    };

  };

}