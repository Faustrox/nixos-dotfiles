{ config, pkgs, ... }:

{

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  gtk = {
    enable = true;
    theme.name = "adw-gtk3-dark";
    cursorTheme.name = "Simp1e-Adw-Dark";
    iconTheme.name = "Papirus-Dark";
  };
  
}