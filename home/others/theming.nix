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

    stylix.iconTheme = {
      enable = true;
      dark = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "sapphire";
      };
    };

    # Fix Catppuccin-cursor inconsistant size Hyprcursor (32) and XCursor (24)
    gtk.cursorTheme = {
      name = "catppuccin-mocha-dark-cursors";
      size = lib.mkForce 24;
    };

    # # QT Theming

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
      qtDir = "${qtTheme}/share/Kvantum/${qtThemeName}";
    in
    {

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
