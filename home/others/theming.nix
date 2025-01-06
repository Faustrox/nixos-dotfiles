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

    home.pointerCursor = {
      name = "catppuccin-mocha-dark-cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 24;
      x11.enable = true;
      gtk.enable = true;
    };

    home.sessionVariables = {
      HYPRCURSOR_THEME = "catppuccin-mocha-dark-cursors";
      HYPRCURSOR_SIZE = 24;
    };

    # GTK Theming

    dconf = {
      enable = true;
      settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };
    
    gtk = {
      enable = true;
      theme =
        let
          cfg = {
            flavor = "mocha";
            accent = "sapphire";
            size = "standard";
            tweaks = [ "rimless" ];
          };
          gtkTweaks = "+" + lib.concatStringsSep "," cfg.tweaks;
        in
        {
          name =
            "catppuccin-${cfg.flavor}-${cfg.accent}-${cfg.size}"
            + gtkTweaks;
          package = pkgs.catppuccin-gtk.override {
            inherit (cfg) size tweaks;
            accents = [ cfg.accent ];
            variant = cfg.flavor;
          };
        };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.catppuccin-papirus-folders.override {
          flavor = "mocha";
          accent = "sapphire";
        };
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

    xdg.configFile = 
    let
      gtk4Dir = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0";
      qtDir = "${qtTheme}/share/Kvantum/${qtThemeName}";
    in
    {

      "gtk-4.0/assets".source = "${gtk4Dir}/assets";
      "gtk-4.0/gtk.css".source = "${gtk4Dir}/gtk.css";
      "gtk-4.0/gtk-dark.css".source = "${gtk4Dir}/gtk-dark.css";

      "Kvantum/catppuccin/catppuccin.kvconfig".source = "${qtDir}/${qtThemeName}.kvconfig";
      "Kvantum/catppuccin/catppuccin.svg".source = "${qtDir}/${qtThemeName}.svg";
      "Kvantum/kvantum.kvconfig".text = "theme=catppuccin";

      "kdeglobals".source = "${(pkgs.catppuccin-kde.override {
        flavour = ["mocha"];
        accents = ["sapphire"];
        winDecStyles = ["modern"];
      })}/share/color-schemes/catppuccinmochasapphire.colors";

    };

  };

}
