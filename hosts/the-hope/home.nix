{ lib, config, pkgs, ... }:

{

  catppuccin = {
    flavor = "mocha";
    accent = "sapphire";
    btop.enable = false;
    kitty.enable = false;
    # rofi.enable = true;
  };

  # --- Home Manager Settings ---

  home.username = "faustrox";
  home.homeDirectory = "/home/${config.home.username}";

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  home.stateVersion = "25.05";
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # --- Desktop Settings ---

  dconf.setup = false;
  hyprland.setup = true;

  # --- Programs Settings ---

  git.setup = true;
  nvf.setup = true;
  wlogout.setup = true;
  zsh.setup = true;


  stylix = {
    enable = true;
    image = ../../assets/wallpapers/nix-catppuccin-alt.png;
    targets.vscode.enable = false;
  };

  programs = {
    btop = {
      enable = true;
      package = pkgs.btop.override { cudaSupport = true; };
    };
    # cava = { # Build errors on nixos-unstable
    #   enable = true;
    # };
    firefox = {
      enable = true;
      nativeMessagingHosts = with pkgs; [ uget-integrator firefoxpwa ];
    };
    kitty = {
      enable = true; 
      shellIntegration.enableZshIntegration = true;
      
      settings = {
        cursor_trail = 3;
      };
      font = {
        name = lib.mkForce "Hack Nerd Font";
        package = lib.mkForce pkgs.nerd-fonts.hack;
      };
    };
    obs-studio = {
      enable = false;
      plugins = with pkgs.obs-studio-plugins; [ droidcam-obs ]; 
    };
    rofi = {
      enable = false;
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
    gifsicle

    # Themes, cursors and icons
    adw-gtk3
    adwsteamgtk

    # Browsers
    firefoxpwa
    google-chrome

    # Developer
    vscode-fhs
    nodejs_20
    yarn
    python3
    
    # Dependencies
    spirv-headers
    glslang
    pinentry-gnome3

    # Utils
    transmission_4-gtk
    httpie
    vrrtest
    qalculate-gtk
    jq
    usbimager
    gpu-screen-recorder
    gpu-screen-recorder-gtk
    kdePackages.kruler

    # Design
    gimp
    inkscape

    # Others
    uget
    libnotify
    
  ];

  home.file = {
    "Pictures/Wallpapers/nix-catppuccin-alt.png".source = ../../assets/wallpapers/nix-catppuccin-alt.png;
    "Pictures/Wallpapers/nix-catppuccin-sapphire.png".source = ../../assets/wallpapers/nix-catppuccin-sapphire.png;
    "Pictures/${config.home.username}.jpg".source = ../../assets/Faustrox.jpg;
  };

  xdg = {
    enable = true;
    userDirs.enable = true;
    userDirs.createDirectories = true;
    # desktopEntries = {
    #   code = {
    #     name = "Visual Studio Code";
    #     exec = "code --disable-gpu-compositing %F";
    #     terminal = false;
    #     genericName = "Text Editor";
    #     type = "Application";
    #     icon = "vscode";
    #     categories = [
    #       "Utility"
    #       "TextEditor"
    #       "Development"
    #       "IDE"
    #     ];
    #     mimeType = [
    #       "text/plain"
    #     ];
    #   };
    # };
    mimeApps = {
      defaultApplications = {
        "default-web-browser" = [ "firefox.desktop" ];
        "text/html" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/about" = [ "firefox.desktop" ];
        "x-scheme-handler/unknown" = [ "firefox.desktop" ];
      };
    };
  };

  # Others Settings

  gaming.setup = true;

  theming.setup = true;

}
