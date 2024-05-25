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

    home.packages = with pkgs; [
      (catppuccin-kvantum.override {
        variant = "Mocha";
        accent = "Sapphire";
      })
      # The following is a Qt theme engine, which can be configured with kvantummanager
      libsForQt5.qtstyleplugin-kvantum
      libsForQt5.qt5ct
    ];
    
    gtk = {
      enable = true;
      catppuccin = {
        enable = config.theming.catppuccin;
        flavour = "mocha";
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

    qt = {
      enable = true;
      platformTheme.name = "qtct";
      style.name = "kvantum";
    };

    xdg.configFile."Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini { }).generate "kvantum.kvconfig" {
      General.theme = "Catppuccin-Mocha-Sapphire";
    };

    home.sessionVariables = {
      GTK_THEME = "Catppuccin-Mocha-Standard-Sapphire-Dark";
      QT_STYLE_OVERRIDE = "kvantum";
    };


  };

}