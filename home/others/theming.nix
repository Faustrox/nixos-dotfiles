{ lib, config, pkgs, ... }:
let

  qtTheme = pkgs.catppuccin-kvantum.override {
    variant = "mocha";
    accent = "sapphire";
  };

  qtThemeName = "catppuccin-mocha-sapphire";

in
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
      qt5.qttools
      qt6Packages.qtstyleplugin-kvantum
      libsForQt5.qtstyleplugin-kvantum

      qtTheme

    ];

    qt = {
      enable = true;
      platformTheme.name = "kvantum";
      style.name = "kvantum";
    };

    xdg.configFile = {

      "Kvantum/catppuccin/catppuccin.kvconfig".source = "${qtTheme}/share/Kvantum/${qtThemeName}/${qtThemeName}.kvconfig";
      "Kvantum/catppuccin/catppuccin.svg".source = "${qtTheme}/share/Kvantum/${qtThemeName}/${qtThemeName}.svg";
      "Kvantum/kvantum.kvconfig".text = "theme=catppuccin";

      "kdeglobals".source = "${(pkgs.catppuccin-kde.override {
        flavour = ["mocha"];
        accents = ["sapphire"];
        winDecStyles = ["modern"];
      })}/share/color-schemes/CatppuccinMochaSapphire.colors";

    };


  };

}