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
  
  home.packages = with pkgs; [
    # Terminal
    zsh-powerlevel10k

    # Gaming
    discord
    lutris
    prismlauncher
    mangohud
    inputs.suyu-emu.packages.x86_64-linux.suyu-mainline

    # Social media
    telegram-desktop
    whatsapp-for-linux

    # Multimedia
    stremio
    # spotify
    nur.repos.nltch.spotify-adblock
    obs-studio

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
    jdk17

    # Utils
    dconf
  ];

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
