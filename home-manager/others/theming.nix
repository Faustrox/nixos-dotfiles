{ lib, config, pkgs, ... }:

{
  options = {
    theming.setup = 
      lib.mkEnableOption "Enable and configure theming in system";
    theming.catppuccin =
      lib.mkEnableOption "Configure catppuccin theming";
    theming.cursor.pkg = 
      lib.mkOption {
        default = pkgs.simp1e-cursors;
        description = "Cursor package";
      };
    theming.cursor.name = 
      lib.mkOption {
        default = "Simp1e-Adw-Dark";
        description = "Cursor name";
      };
    theming.qt.platformTheme = 
      lib.mkOption {
        default = "gnome";
        description = "Platform's name to use";
      };
    theming.qt.styleName =
      lib.mkOption {
        default = "adwaita-dark";
        description = "Style's theme name";
      };
    theming.qt.stylePkg =
      lib.mkOption {
        default = pkgs.adwaita-qt;
        description = "Style's package";
      };
  };

  config = lib.mkIf config.theming.setup {

    home.pointerCursor = {
      package = if config.theming.catppuccin 
                then pkgs.simp1e-cursors
              else config.theming.cursor.pkg;
      name = if config.theming.catppuccin 
                then "Simp1e-Catppuccin-Mocha" 
              else config.theming.cursor.name;
      size = 24;
    };

    # GTK Theming

    dconf = {
      enable = true;
      settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };
    
    gtk = {
      enable = true;
      catppuccin = {
        enable = config.theming.catppuccin;
        flavor = "mocha";
        accent = "sapphire";
        size = "standard";
        tweaks = [ "rimless" ];
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.catppuccin-papirus-folders.override {
          flavor = "mocha";
          accent = "sapphire";
        };
      };
      cursorTheme = {
        name = "Simp1e-Catppuccin-Mocha";
        package = pkgs.simp1e-cursors;
      };
    };

    # QT Theming

    home.packages = with pkgs; [
      # The following is a Qt theme engine, which can be configured with kvantummanager
      kdePackages.qtstyleplugin-kvantum
    ];

    xdg.configFile."kdeglobals".source = "${(pkgs.catppuccin-kde.override {
      flavour = ["mocha"];
      accents = ["sapphire"];
      winDecStyles = ["modern"];
    })}/share/color-schemes/CatppuccinMochaSapphire.colors";

    qt = {
      enable = true;
      platformTheme.name = "qtct";
      style = {
        package = pkgs.catppuccin-kde;
        name = "kvantum";
      };
    };

    xdg.configFile."Kvantum/catppuccin/catppuccin.kvconfig".source = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/Kvantum/main/src/Catppuccin-Mocha-Peach/Catppuccin-Mocha-Peach.kvconfig";
      sha256 = "bf6e3ad5df044e7efd12c8bf707a67a69dd42c9effe36abc7eaa5eac12cd0a3c";
    };
    xdg.configFile."Kvantum/catppuccin/catppuccin.svg".source = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/Kvantum/main/src/Catppuccin-Mocha-Peach/Catppuccin-Mocha-Peach.svg";
      sha256 = "fbd5c968afdd08812f55cfb5ad9eafb526a09d8c027e6c4378e16679e5ae44ae";
    };
    xdg.configFile."Kvantum/kvantum.kvconfig".text = "theme=catppuccin";

    home.file = {
      ".config/kitty/kitty.conf".source = ./config/kitty-catppuccin-mocha.conf;
      # ".config/Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini { }).generate "kvantum.kvconfig" {
      #   theme = "catppuccin";
      # };
    };

    wayland.windowManager.hyprland.catppuccin.enable = true;
    services.dunst.catppuccin.enable = true;

    home.sessionVariables = {
      GTK_THEME = "Catppuccin-Mocha-Standard-Sapphire-Dark";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    };


  };

}