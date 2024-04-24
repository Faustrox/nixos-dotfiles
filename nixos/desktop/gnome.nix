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
        gnome-console
      ]) ++ (with pkgs.gnome; [
        epiphany # web browser
      ]);

      # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
      systemd.services."getty@tty1".enable = false;
      systemd.services."autovt@tty1".enable = false;
      
      services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

      # Gnome Keyring
      services.gnome.gnome-keyring.enable = true;
      security.pam.services.gdm.enableGnomeKeyring = true;
      programs.ssh.startAgent = true;
      
      # To Dynamic Triple Buffering to work
      nixpkgs.config.allowAliases = false;

      environment.systemPackages = (with pkgs; [
        celluloid
        fragments
        gnome.gnome-themes-extra
        gnome.gnome-tweaks
        gparted
      ]) ++ (with pkgs.gnomeExtensions; [
        appindicator
        compiz-windows-effect
        burn-my-windows
        coverflow-alt-tab
        gamemode-indicator-in-system-settings
        just-perfection
        pano
        tiling-assistant
        top-bar-organizer
        quick-settings-tweaker
        gnome-40-ui-improvements
      ]);

      environment.sessionVariables = lib.mkIf config.gnome.wayland {
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland";
        MOZ_ENABLE_WAYLAND = "1";
      };

    };

}