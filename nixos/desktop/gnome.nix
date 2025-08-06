{ config, pkgs, lib, inputs, ... }: 

{

  options = {
    gnome.enable = 
      lib.mkEnableOption "Enable Gnome wayland";
  };

  config = lib.mkIf config.gnome.enable {

    # Enable the GNOME Desktop Environment.
    services = {
      desktopManager.gnome.enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };

      displayManager.autoLogin = {
        enable = true;
        user = config.main-user.username;
      };
    };

    # Exclude base gnome packages
    services.xserver.desktopManager.xterm.enable = false;
    environment.gnome.excludePackages = (with pkgs; [
      atomix # puzzle game
      cheese # webcam tool
      epiphany # web browser
      evince # document viewer
      geary # email reader
      gedit # text editor
      gnome-characters
      gnome-music
      gnome-photos
      gnome-terminal
      gnome-tour
      hitori # sudoku game
      iagno # go game
      tali # poker game
      totem # video player
    ]);

    # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
    systemd.services."getty@tty1".enable = false;
    systemd.services."autovt@tty1".enable = false;
    
    services.udev.packages = with pkgs; [ gnome-settings-daemon ];

    # Gnome Keyring
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.gdm.enableGnomeKeyring = true;
    
    # To Dynamic Triple Buffering to work
    # nixpkgs.config.allowAliases = false;

    environment.systemPackages = with pkgs; [
      gnome-themes-extra
      gnome-tweaks
      dconf-editor
      gparted
      menulibre
    ];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = 1;
      # ELECTRON_OZONE_PLATFORM_HINT = "auto";
      MOZ_ENABLE_WAYLAND = 1;
      MOZ_DBUS_REMOTE = 1;

      GDK_BACKEND = "wayland,x11,*";
      QT_QPA_PLATFORM = "wayland;xcb";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
    };

  };

}