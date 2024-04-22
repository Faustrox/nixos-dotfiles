{ config, pkgs, inputs, ... }:

{

  catppuccin.flavour = "mocha";

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

    # Social media
    telegram-desktop
    zapzap

    # Multimedia
    stremio
    spotify
    ffmpeg-full

    # Themes, cursors and icons
    adw-gtk3
    simp1e-cursors
    catppuccin-papirus-folders

    # Browsers
    google-chrome

    # Developer
    vscode
    nodejs_20
    yarn
    
    # Dependencies
    spirv-headers
    glslang
    libgcc

    # Utils
    menulibre
    vrrtest
    kdePackages.kalk
    dconf
    jq
    
  ];

  home.sessionVariables = {
    SCRIPTS_FOLDER = "$HOME/.scripts";
    FLAKE = "$HOME/.dotfiles";
    WEBKIT_DISABLE_COMPOSITING_MODE = "1"; # Fixes problems for logins in Lutris and other apps
  };

  home.sessionPath = [
    "$SCRIPTS_FOLDER"
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
