{ lib, config, pkgs, inputs, ... }:

{

  options = {
    gaming.setup = 
      lib.mkEnableOption "Configure and install gaming packages";
  };

  config = lib.mkIf config.gaming.setup {
    
    # nix.settings = {
    #   substituters = lib.mkBefore ["https://nix-gaming.cachix.org"];
    #   trusted-public-keys = lib.mkBefore ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
    # };


    home.packages = with pkgs;
    let
      game-pkgs = inputs.nix-gaming.packages.x86_64-linux;
      suyu-emu = inputs.suyu-emu.packages.x86_64-linux;
    in [

      # Social
      discord

      # Emulators
      suyu-emu.suyu-mainline

      # Launchers
      lutris
      prismlauncher
      heroic

      # Utils
      mangohud
      goverlay
      wineWow64Packages.full
      winetricks
      protonup-qt
      protonup-ng
      protontricks
      vkbasalt
      steamPackages.steamcmd

    ];
    

    xdg.desktopEntries = {
      "dev.suyu_emu.suyu" = {
        name = "Suyu";
        genericName = "Switch Emulator";
        comment = "Nintendo Switch video game console emulator";
        exec = "gamemoderun suyu %f";
        terminal = false;
        type = "Application";
        categories = [ "Game" "Emulator" ];
        icon = "dev.suyu_emu.suyu";
        mimeType = [ "application/x-nx-nro" "application/x-nx-nso" "application/x-nx-nsp" "application/x-nx-xci" ];
      };
    };

  };

}