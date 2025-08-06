{ pkgs, ... }:
let
  nvibrantAutostart = pkgs.writeText "nvibrant.desktop" ''
    [Desktop Entry]
    Type=Application
    Name=nVibrant
    Exec=nvibrant 256 0 0
    NoDisplay=true
  '';
in
{
  xdg.enable = true;
  # Autostart desktop files
  xdg.autostart = {
    enable = true;
    entries = [ nvibrantAutostart ];
  };

}