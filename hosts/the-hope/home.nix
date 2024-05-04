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

    # Multimedia
    stremio
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
  };

  home.sessionPath = [
    "$SCRIPTS_FOLDER"
  ];

  xdg = {
    enable = true;
    desktopEntries = {
      "nvidia.load.settings" = {
        name = "NVIDIA Load Settings";
        genericName = "NVIDIA";
        comment = "Load NVIDIA settings without gui";
        exec = "nvidia-settings --load-config-only";
        terminal = false;
        type = "Application";
        icon = "nvidia";
      };
      "noisetorch.load.input" = {
        name = "NoiseTorch Load Input";
        genericName = "NoiseTorch";
        comment = "Load NoiseTorch suppressor for input";
        exec = "noisetorch -i";
        terminal = false;
        type = "Application";
        icon = "noisetorch";
      };
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
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

}
