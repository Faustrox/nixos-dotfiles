{ config, pkgs, inputs, ... }:

{

  catppuccin = {
    flavor = "mocha";
    accent = "sapphire";
  };

  # --- Home Manager Settings ---

  home.username = "faustrox";
  home.homeDirectory = "/home/faustrox";

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  home.stateVersion = "24.05";

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
    vscode.enable = true;
    obs-studio.enable = true;
    kitty = {
      enable = true;
      catppuccin.enable = true;
    };
  };
  
  home.packages = with pkgs; [

    # Terminal
    zsh-powerlevel10k

    # Social media
    telegram-desktop

    # Multimedia
    stremio
    ani-cli
    mpv
    celluloid
    ffmpeg-full

    # Themes, cursors and icons
    adw-gtk3
    adwsteamgtk

    # Browsers
    google-chrome

    # Developer
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
      code = {
        name = "Visual Studio Code";
        exec = "code --disable-gpu-compositing %F";
        terminal = false;
        genericName = "Text Editor";
        type = "Application";
        icon = "vscode";
        categories = [
          "Utility"
          "TextEditor"
          "Development"
          "IDE"
        ];
        mimeType = [
          "text/plain"
        ];
      };
    };
  };

  # Others Settings

  gaming.setup = true;

  theming.setup = true;

}
