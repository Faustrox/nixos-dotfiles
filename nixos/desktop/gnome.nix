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
    services.xserver = {
      displayManager.gdm = {
        enable = true;
        wayland = config.gnome.wayland;
      };
      desktopManager.gnome = {
        enable = true;
        # extraGSettingsOverridePackages = [ pkgs.gnome.mutter ];
      };
    };

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
    # nixpkgs.config.allowAliases = false;

    environment.systemPackages = with pkgs; [
      gnome-themes-extra
      gnome-tweaks
      dconf-editor
      gparted
      menulibre
    ];

    environment.sessionVariables = lib.mkMerge [
      (lib.mkIf config.gnome.wayland {
        MUTTER_DEBUG_DISABLE_HW_CURSORS = 1;
        CLUTTER_PAINT = "disable-dynamic-max-render-time";
      })
    ]; 

  };

}