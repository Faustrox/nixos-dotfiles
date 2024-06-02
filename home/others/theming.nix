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
      flavour = [ "mocha" ];
      accents = [ "sapphire" ];
      winDecStyles = [ "modern" ];
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
      url = "https://raw.githubusercontent.com/catppuccin/Kvantum/main/src/Catppuccin-Mocha-Sapphire/Catppuccin-Mocha-Sapphire.kvconfig";
      sha256 = "0n9f5hysr4k1sf9fd3sgd9fvqwrxrpcvj6vajqmb5c5ji8nv2w3c";
    };
    xdg.configFile."Kvantum/catppuccin/catppuccin.svg".source = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/Kvantum/main/src/Catppuccin-Mocha-Sapphire/Catppuccin-Mocha-Sapphire.svg";
      sha256 = "1hq9h34178h0d288hgwb0ngqnixz24m9lk0ahc4dahwqn77fndwf";
    };
    xdg.configFile."Kvantum/kvantum.kvconfig".text = "theme=catppuccin";

    home.file = {
      ".config/kitty/kitty.conf".source = ./config/kitty-catppuccin-mocha.conf;
    };

    home.sessionVariables = {
      GTK_THEME = "Catppuccin-Mocha-Standard-Sapphire-Dark";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    };


  };

}