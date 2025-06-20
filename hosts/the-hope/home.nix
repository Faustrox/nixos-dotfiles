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
  vscode.setup = true;
  fish.setup = true;
  # zsh.setup = true;
  # nushell.setup = true;


  stylix = {
    enable = true;
    image = ../../assets/wallpapers/nix-catppuccin-alt.png;
    targets.vscode.enable = false;
  };

  programs = {
    floorp.enable = true;
    fastfetch.enable = true;
    fd.enable = true;
    bat.enable = true;

    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };

    btop = {
      enable = true;
      package = pkgs.btop.override { cudaSupport = true; };
    };

    wezterm = {
      enable = true;
      # enableZshIntegration = true;

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
  };
  
  home.packages = with pkgs; [

    # google-chrome

    # Terminal
    # zsh-powerlevel10k

    # Social media
    telegram-desktop

    # Multimedia
    loupe
    stremio
    # mpv # Wayland flicks
    vlc
    ffmpeg-full
    gifsicle

    # Themes, cursors and icons
    # adw-gtk3
    adwsteamgtk

    # Developer
    code-cursor
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

    # Design
    # gimp
    # inkscape

    # Trading
    tradingview

    # Others
    obsidian
    uget
    libnotify
    rquickshare
    
  ];

  home.file = {
    "Pictures/Wallpapers/nix-catppuccin-alt.png".source = ../../assets/wallpapers/nix-catppuccin-alt.png;
    "Pictures/Wallpapers/nix-catppuccin-sapphire.png".source = ../../assets/wallpapers/nix-catppuccin-sapphire.png;
    "Pictures/${config.home.username}.jpg".source = ../../assets/Faustrox.jpg;
  };

  xdg = {
    enable = true;
    mime.enable = true;
    userDirs.enable = true;
    userDirs.createDirectories = true;
    desktopEntries = {
      code = {
        name = "Visual Studio Code";
        exec = "cursor";
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

        # Images
        "image/jpeg" = "loupe.desktop";
        "image/png" = "loupe.desktop";
        "image/gif" = "loupe.desktop";
        "image/webp" = "loupe.desktop";
        "image/bmp" = "loupe.desktop";
        "image/tiff" = "loupe.desktop";
        "image/svg+xml" = "loupe.desktop";
        "image/x-xbitmap" = "loupe.desktop";
        "image/x-icon" = "loupe.desktop";
        "image/vnd.microsoft.icon" = "loupe.desktop";
        "image/*" = ["loupe.desktop" "feh.desktop"];

        # Videos
        "video/mp4" = "vlc.desktop";
        "video/x-matroska" = "vlc.desktop";
        "video/x-msvideo" = "vlc.desktop";
        "video/webm" = "vlc.desktop";
        "video/*" = "vlc.desktop";

        "text/*" = "code.desktop";
        "text/css" = "code.desktop";
        "text/html" = "floorp.desktop";
        "text/plain" = "code.desktop";
      };
      associations.added = {
        "image/jpeg" = ["loupe.desktop" "feh.desktop"];
        "image/png" = ["loupe.desktop" "feh.desktop"];
        "image/gif" = ["loupe.desktop" "feh.desktop"];
        "image/webp" = ["loupe.desktop" "feh.desktop"];
        "image/bmp" = ["loupe.desktop" "feh.desktop"];
        "image/tiff" = ["loupe.desktop" "feh.desktop"];
        "image/svg+xml" = ["loupe.desktop" "feh.desktop"];
        "image/x-xbitmap" = ["loupe.desktop" "feh.desktop"];
        "image/x-icon" = ["loupe.desktop" "feh.desktop"];
        "image/vnd.microsoft.icon" = ["loupe.desktop" "feh.desktop"];
        "image/*" = ["loupe.desktop" "feh.desktop"];
        "video/mp4" = "vlc.desktop";
        "video/x-matroska" = "vlc.desktop";
        "video/x-msvideo" = "vlc.desktop";
        "video/webm" = "vlc.desktop";
        "video/*" = "vlc.desktop";
      };
      associations.removed = {
        "inode/directory" = "code.desktop";
        "image/*" = "google-chrome.desktop";
        "video/mp4" = "stremio.desktop";
        "video/x-matroska" = "stremio.desktop";
        "video/*" = "stremio.desktop";
      };
    };
  };

  # Others Settings

  gaming.setup = true;

  theming.setup = true;

}
