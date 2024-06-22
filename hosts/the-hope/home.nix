{ config, pkgs, inputs, ... }:

{

  catppuccin = {
    flavor = "mocha";
    accent = "sapphire";
  };

  # --- Home Manager Settings ---

  home.username = "faustrox";
  home.homeDirectory = "/home/faustrox";

  home.sessionVariables = {
    SCRIPTS_FOLDER = "$HOME/.scripts";
  };

  home.sessionPath = [
    "$SCRIPTS_FOLDER"
  ];

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  # --- Desktop Settings ---

  dconf.setup = false;
  hyprland.setup = true;

  # --- Programs Settings ---

  git.setup = true;

  zsh.setup = true;

  programs = {
    obs-studio.enable = true;
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

    # Browsers
    google-chrome
    firefox

    # Developer
    vscode
    nodejs_20
    yarn
    python3
    
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
    gimp

    # Others
    fragments
    uget
    
  ];

  xdg = {
    enable = true;
    desktopEntries = {
      # "nvidia.load.settings" = {
      #   name = "NVIDIA Load Settings";
      #   genericName = "NVIDIA";
      #   comment = "Load NVIDIA settings without gui";
      #   exec = "nvidia-settings --load-config-only";
      #   terminal = false;
      #   type = "Application";
      #   icon = "nvidia";
      # };
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

  # Others Settings

  gaming.setup = true;

  theming.setup = true;
  theming.catppuccin = true;

}
