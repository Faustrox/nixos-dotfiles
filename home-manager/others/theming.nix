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

    gtk = {
      enable = true;
      catppuccin.enable = config.theming.catppuccin;
    };

    qt = {
      enable = true;
      platformTheme = config.theming.qt.platformTheme;
      style = {
        name = if config.theming.catppuccin 
                then "Catppuccin-Mocha" 
              else config.theming.qt.styleName;
        package = if config.theming.catppuccin
                    then pkgs.catppuccin-qt5ct
                  else config.theming.qt.stylePkg;
      };
    };

  };

}