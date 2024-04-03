{ pkgs, inputs, ... }:

{

  home.username = "faustrox";
  home.homeDirectory = "/home/faustrox";
  home.pointerCursor = {
    package = pkgs.simp1e-cursors;
    name = "Simp1e-Adw-Dark";
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
    prismlauncher
    mangohud
    suyu-emu.suyu-mainline
    winetricks
    protonup-qt
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
    papirus-icon-theme

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
    dconf
    jq
    
  ];

  programs = {
    obs-studio = {
      enable = true;
      plugins = [ pkgs.obs-studio-plugins.obs-vaapi ];
    };
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
