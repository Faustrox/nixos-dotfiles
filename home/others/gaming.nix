{ lib, config, pkgs, inputs, ... }: let
  inherit (pkgs.stdenv.hostPlatform) system;
  umu = inputs.umu.packages.${system}.umu.override {
    version = inputs.umu.shortRev;
    truststore = true;
    cbor2 = true;
  };
in {

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

    home.packages = with pkgs; [

      # Social
      # discord
      vesktop

      # Emulators
      suyu

      # Launchers
      # (lutris.override {
      #   extraPkgs = pkgs: [
      #     wineWowPackages.stable
      #     winetricks
      #   ];
      # })
      prismlauncher
      heroic-unwrapped
      # arma3-unix-launcher
      umu
      cartridges
      rpcs3

      # Wine
      wineWowPackages.stable
      winetricks
      mono

      # Utils
      glfw-wayland
      mangohud
      goverlay
      protonup-qt
      protonup-ng
      vkbasalt
      steamcmd

    ];

    programs = {
      java = {
        enable = true;
        package = pkgs.jdk17;
      };

      zsh.shellAliases = {
        # umu-launcher = "LD_BIND_NOW=1 STAGING_WRITECOPY=1 STAGING_SHARED_MEMORY=1 WINEDEBUG=-all ENABLE_VKBASALT=1 gamemoderun mangohud umu-run";
        dayz-launch = "$HOME/.dotfiles/home/others/scripts/dayz-launcher.sh";
        # bdiscord-install = "nix run nixpkgs#betterdiscordctl install";
      };
    };

    home = {
      file.".config/vkBasalt".source = ../config/vkBasalt;
      sessionVariables = {
        STEAM_ROOT = config.gaming.steamRoot;
        DXVK_STATE_CACHE_PATH = "/home/${config.home.username}/.cache/dxvk";
        PROTON_HIDE_NVIDIA_GPU = 0;
        DXVK_HUD = "compiler";
        DXVK_ASYNC = 1;
        MANGOHUD = 1;
        WINEESYNC = 1;
        WINEFSYNC = 1;
        VKD3D_CONFIG = "dxr11,dxr";
        PROTON_ENABLE_NVAPI = 1;
        WEBKIT_DISABLE_COMPOSITING_MODE = 1; # Fixes problems for logins in Lutris and other apps
      };
    };
  };
}
