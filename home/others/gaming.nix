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
      suyu = inputs.suyu.packages.${pkgs.system};
      umu = inputs.umu.packages.${pkgs.system};
    in [

      # Social
      discord

      # Emulators
      suyu.suyu

      # Launchers
      lutris
      prismlauncher
      heroic
      umu.umu

      # Wine
      wineWowPackages.stableFull
      winetricks
      # bottles

      # Utils
      mangohud
      goverlay
      protonup-qt
      protonup-ng
      vkbasalt
      steamPackages.steamcmd

    ];

    programs = {
      java.enable = true;

      zsh.shellAliases = {
        umu-launcher = "ENABLE_VKBASALT=1 gamemoderun mangohud umu-run";
        dayz-launch = "./scripts/dayz-launcher.sh";
        bdiscord-install = "nix run nixpkgs#betterdiscordctl install";
      };
    };

    home.sessionVariables = {
      STEAM_ROOT = config.gaming.steamRoot;
      __GL_SHADER_DISK_CACHE = 1;
      __GL_SHADER_DISK_CACHE_PATH = "/home/faustrox/.shaders";
      __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = 1;
      VKBASALT_CONFIG_FILE = "/mnt/games/Reshade/vkBasalt.conf";
      PROTON_HIDE_NVIDIA_GPU = 0;
      DXVK_HUD = "compiler";
      DXVK_ASYNC = 1;
      WEBKIT_DISABLE_COMPOSITING_MODE = 1; # Fixes problems for logins in Lutris and other apps
    };

  };

}