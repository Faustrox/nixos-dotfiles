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
      arma3-unix-launcher
      umu.umu

      # Wine
      wineWowPackages.waylandFull
      winetricks

      # Utils
      mangohud_git
      goverlay
      protonup-qt
      protonup-ng
      vkbasalt
      steamPackages.steamcmd

    ];

    programs = {
      java = {
        enable = true;
        package = pkgs.jdk17;
      };

      zsh.shellAliases = {
        umu-launcher = "gamemoderun mangohud umu-run";
        dayz-launch = "$HOME/.dotfiles/home/others/scripts/dayz-launcher.sh";
        bdiscord-install = "nix run nixpkgs#betterdiscordctl install";
      };
    };

    home = {
      file.".config/vkBasalt/vkBasalt.conf".source = ../config/vkBasalt/vkBasalt.conf;

      sessionVariables = {
          STEAM_ROOT = config.gaming.steamRoot;
          __GL_SHADER_DISK_CACHE = 1;
          __GL_SHADER_DISK_CACHE_PATH = "$HOME/.shaders";
          __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = 1;
          PROTON_HIDE_NVIDIA_GPU = 0;
          DXVK_HUD = "compiler";
          DXVK_ASYNC = 1;
          MANGOHUD = 1;
          WINEESYNC = 1;
          WINEFSYNC = 1;
          WEBKIT_DISABLE_COMPOSITING_MODE = 1; # Fixes problems for logins in Lutris and other apps
      };
    };
  };
}