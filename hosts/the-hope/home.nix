{ config, pkgs, lib, ... }:

{

  imports = [
    ../../modules/programs
    ../../modules/gtk-themes/adw-gtk3.nix
  ];

  home.username = "faustrox";
  home.homeDirectory = "/home/faustrox";

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };
  
  home.packages = with pkgs; [
    # Terminal
    zsh-powerlevel10k

    # Gaming
    steam
    discord
    lutris
    gamemode

    # Social media
    telegram-desktop
    whatsapp-for-linux

    # GTK theme, cursor and icons
    adw-gtk3
    simp1e-cursors
    papirus-icon-theme

    # Gnome Extensions
    gnomeExtensions.blur-my-shell
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.gamemode-indicator-in-system-settings

    # Browsers
    google-chrome

    # Developer
    vscode
    nodejs_20

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
