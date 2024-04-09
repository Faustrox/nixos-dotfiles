{ config, pkgs, inputs, ... }:

{

  catppuccin.flavour = "mocha";

  home.username = "faustrox";
  home.homeDirectory = "/home/faustrox";
  home.pointerCursor = {
    package = pkgs.simp1e-cursors;
    name = "Simp1e-Catppuccin-Mocha";
    size = 24;
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  git.userName = "Fausto Jáquez";
  git.userEmail = "Faustojr03@gmail.com";
  
  home.packages = with pkgs; 
  let
    gamePkgs = inputs.nix-gaming.packages.x86_64-linux;
    suyu-emu = inputs.suyu-emu.packages.x86_64-linux;
  in
  [
    # Terminal
    zsh-powerlevel10k

    # Gaming
    discord
    lutris
    heroic
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

    # Social media
    telegram-desktop
    zapzap

    # Multimedia
    stremio
    # spotify
    nur.repos.nltch.spotify-adblock
    ffmpeg-full

    # Themes, cursors and icons
    adw-gtk3
    simp1e-cursors
    catppuccin-papirus-folders

    # Gnome Extensions
    # gnomeExtensions.blur-my-shell
    # gnomeExtensions.tray-icons-reloaded
    # gnomeExtensions.gamemode-indicator-in-system-settings

    # Browsers
    google-chrome

    # Developer
    vscode
    nodejs_20

    # Utils
    vrrtest
    kdePackages.kalk
    dconf
    jq
    
  ];

  programs = {
    obs-studio = {
      enable = true;
    };
  };

  home.sessionVariables = {
    SCRIPTS_FOLDER = "$HOME/.scripts";
    GAMES_DRIVE = "/mnt/games";
    STEAM_ROOT = "$GAMES_DRIVE/Libreries/Steam";
  };

  home.sessionPath = [
    "$SCRIPTS_FOLDER"
  ];

  xdg.desktopEntries = {
    "net.lutris.Lutris" = {
      name = "Lutris";
      comment = "Video Game Preservation Platform";
      exec = "WEBKIT_DISABLE_COMPOSITING_MODE=1 lutris";
      terminal = false;
      type = "Application";
      categories = [ "Game" ];
      icon = "lutris";
      mimeType = [ "x-scheme-handler/lutris" ];
    };
    "org.suyu_emu.suyu" = {
      name = "suyu";
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

  gtk = {
    enable = true;
    catppuccin.enable = true;
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

}
