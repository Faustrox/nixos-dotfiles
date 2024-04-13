{ config, pkgs, lib, inputs, ... }:

{

  options = {
    gnome.enable = 
      lib.mkEnableOption "Enable Gnome wayland";
    gnome.wayland =
      lib.mkEnableOption "Use Wayland for GDM and Gnome";
  };

  config = lib.mkIf config.gnome.enable {

      # Enable the GNOME Desktop Environment.
      services.xserver.displayManager.gdm = {
        enable = true;
        wayland = config.gnome.wayland;
      };
      services.xserver.desktopManager.gnome.enable = true;

      # Exclude base gnome packages
      services.xserver.desktopManager.xterm.enable = false;
      environment.gnome.excludePackages = (with pkgs; [
        gnome-tour
      ]) ++ (with pkgs.gnome; [
        epiphany # web browser
      ]);

      # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
      systemd.services."getty@tty1".enable = false;
      systemd.services."autovt@tty1".enable = false;
      
      services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
      services.gnome.gnome-keyring.enable = true;

      environment.systemPackages = with pkgs; [
        gparted
        fragments
        gnome.gnome-themes-extra
        gnome.gnome-tweaks
        gnomeExtensions.just-perfection
        gnomeExtensions.pano
        gnomeExtensions.appindicator
        gnomeExtensions.tiling-assistant
      ];

    };

}