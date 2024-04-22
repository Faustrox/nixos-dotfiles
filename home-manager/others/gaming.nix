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

    home.sessionVariables = {
      STEAM_ROOT = config.gaming.steamRoot;
    };

    home.packages = with pkgs;
    let
      gamePkgs = inputs.nix-gaming.packages.x86_64-linux;
      suyu-emu = inputs.suyu-emu.packages.x86_64-linux;
    in [

      # Gaming
      discord
      heroic
      lutris
      mangohud
      egl-wayland
      prismlauncher
      suyu-emu.suyu-mainline
      wineWowPackages.stable
      winetricks
      protonup-qt
      protontricks
      vkbasalt
      steamPackages.steamcmd

    ];

    xdg.desktopEntries = {
      suyu = {
        name = "Suyu";
        genericName = "Switch Emulator";
        comment = "Nintendo Switch video game console emulator";
        exec = "gamemoderun suyu %f";
        terminal = false;
        type = "Application";
        categories = [ "Game" "Emulator" ];
        icon = "org.suyu_emu.suyu";
        mimeType = [ "application/x-nx-nro" "application/x-nx-nso" "application/x-nx-nsp" "application/x-nx-xci" ];
      };
    };

  };

}