{ lib, config, pkgs, ... }:

{
  options = {
    theming.setup = 
      lib.mkEnableOption "Enable and configure theming in system";
  };

  config = lib.mkIf config.theming.setup {

    home.pointerCursor = {
      package = pkgs.simp1e-cursors;
      name = "Simp1e-Catppuccin-Mocha";
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
        name = "Simp1e-Catppuccin-Mocha";
        package = pkgs.simp1e-cursors;
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
      platformTheme.name = "qtct";
      style = {
        package = pkgs.catppuccin-kde;
        name = "kvantum";
      };
    };

    xdg.configFile = {
      "Kvantum/catppuccin/catppuccin.kvconfig".source = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/Kvantum/main/themes/catppuccin-mocha-sapphire/catppuccin-mocha-sapphire.kvconfig";
        sha256 = "0y4whyz3vj1bjyzwj0qm4d8p60ljxa5r8kg1bk8crlk8ksrk3rbs";
      };
      "Kvantum/catppuccin/catppuccin.svg".source = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/Kvantum/main/themes/catppuccin-mocha-sapphire/catppuccin-mocha-sapphire.svg";
        sha256 = "1hq9h34178h0d288hgwb0ngqnixz24m9lk0ahc4dahwqn77fndwf";
      };
      "Kvantum/kvantum.kvconfig".text = "[General]\ntheme=catppuccin";
    };


    home.file = {
      ".config/kitty/kitty.conf".source = ../config/kitty/kitty.conf;
    };

    home.sessionVariables = {
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    };

  };

}