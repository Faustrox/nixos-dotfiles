{ lib, config, pkgs, ... }:

{

  catppuccin = {
    flavor = "mocha";
    accent = "sapphire";
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
  nvf.setup = false;
  vscode.setup = true;
  zsh.setup = true;


  stylix = {
    enable = true;
    image = ../../assets/wallpapers/nix-catppuccin-alt.png;
    targets.vscode.enable = false;
  };

  programs = {
    floorp.enable = true;

    btop = {
      enable = true;
      package = pkgs.btop.override { cudaSupport = true; };
    };
    firefox = {
      enable = false;
      nativeMessagingHosts = with pkgs; [ uget-integrator firefoxpwa ];
    };

    wezterm = {
      enable = true;
      enableZshIntegration = true;

      extraConfig = ''
        return {
          font = wezterm.font("FiraCode Nerd Font"),
          color_scheme = "Catppuccin Mocha",

          tab_bar_at_bottom = true,
          hide_tab_bar_if_only_one_tab = true,

          default_cursor_style = "BlinkingBar",
          cursor_blink_ease_in = "Ease",
          cursor_blink_ease_out = "Ease"
        }
      '';
    };
    kitty = {
      enable = false; 
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

    # Developer
    nodejs_20
    yarn
    python3
    insomnia
    
    # Dependencies
    spirv-headers
    glslang
    pinentry-gnome3

    # Utils
    transmission_4-gtk
    varia
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

    # Trading
    tradingview

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
    desktopEntries = {
      code = {
        name = "Visual Studio Code";
        exec = "code";
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
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = "org.gnome.Nautilus.desktop";
        "default-web-browser" = "floorp.desktop";
        "application/pdf" = "floorp.desktop";
        "application/vnd.apple.mpegurl" = "";
        "application/x-extension-htm" = "floorp.desktop";
        "application/x-extension-html" = "floorp.desktop";
        "application/x-extension-shtml" = "floorp.desktop";
        "application/x-extension-xht" = "floorp.desktop";
        "application/x-extension-xhtml" = "floorp.desktop";
        "application/x-shellscript" = "";
        "application/xhtml+xml" = "floorp.desktop";
        "x-scheme-handler/http" = "floorp.desktop";
        "x-scheme-handler/https" = "floorp.desktop";
        "x-scheme-handler/about" = "floorp.desktop";
        "x-scheme-handler/unknown" = "floorp.desktop";
        "image/png" = "feh.desktop";
        "text/*" = "code.desktop";
        "text/css" = "code.desktop";
        "text/html" = "floorp.desktop";
        "text/plain" = "code.desktop";
      };
      associations.removed = {
        "inode/directory" = "code.desktop";
      };
    };
  };

  # Others Settings

  gaming.setup = true;

  theming.setup = true;

}
