{ lib, config, pkgs, ... }:

{
  options = {
    theming.setup = 
      lib.mkEnableOption "Enable and configure theming in system";
  };

  config = lib.mkIf config.theming.setup {

    home.pointerCursor.size = 24;

    catppuccin.pointerCursor = {
      enable = true;
      flavor = "mocha";
      accent = "dark";
    };

    # GTK Theming

    dconf = {
      enable = true;
      settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };
    
    gtk = {
      enable = true;
      catppuccin = {
        enable = true;
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
        name = "catppuccin-mocha-dark-cursors";
        package = pkgs.catppuccin-cursors;
      };
    };

    # QT Theming

    home.packages = with pkgs; [
      # The following is a Qt theme engine, which can be configured with kvantummanager
      libsForQt5.qtstyleplugin-kvantum
      kdePackages.qtstyleplugin-kvantum
    ];

    xdg.configFile."kdeglobals".source = "${(pkgs.catppuccin-kde.override {
      flavour = [ "mocha" ];
      accents = [ "sapphire" ];
      winDecStyles = [ "modern" ];
    })}/share/color-schemes/CatppuccinMochaSapphire.colors";

    qt = {
      enable = true;
      platformTheme.name = "kvantum";
      style = {
        name = "kvantum";
        catppuccin.enable = true;
      };
    };

    home.sessionVariables = {
      QT_AUTO_SCREEN_SCALE_FACTOR = 1;
    };

  };

}