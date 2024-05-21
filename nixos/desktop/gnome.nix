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
        extraGSettingsOverridePackages = [ pkgs.gnome.mutter ];
        extraGSettingsOverrides = ''
          [org/gnome/mutter]
            experimental-features="['variable-refresh-rate']"
          [org/gnome/desktop/interface]
            color-scheme="prefer-dark"
        '';
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
    nixpkgs.config.allowAliases = false;

    nixpkgs.overlays = [
      (final: prev: {
        gnome = prev.gnome.overrideScope (gnomeFinal: gnomePrev: {
          mutter = gnomePrev.mutter.overrideAttrs ( old: {
            patches = (old.patches or []) ++ [
              (prev.fetchpatch { # Dynamic Tripple Buffering v4
                url = "https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/1441.patch";
                hash = "sha256-Ngs05xlIN27Rf0XDAhXGMh8bgfryiw4QueHlJA2dJY4=";
              })
              (prev.fetchpatch { # Increase default deadline evasion to 1000 microseconds
                url = "https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/3373.patch";
                hash = "sha256-EC4YcCEQD38ilZ/pHhf18kVkAd5tNZr4PzbqJxNID9Y=";
              })
            ];
          } );
        });
      })
    ];

    programs.dconf.enable = true;

    environment.systemPackages = (with pkgs; [
      celluloid
      fragments
      gnome.gnome-themes-extra
      gnome.gnome-tweaks
      gnome.dconf-editor
      gparted
    ]) ++ (with pkgs.gnomeExtensions; [
      appindicator
      burn-my-windows
      compiz-windows-effect
      gamemode-indicator-in-system-settings
      gnome-40-ui-improvements
      headsetcontrol
      just-perfection
      pano
      quick-settings-tweaker
      tiling-assistant
      top-bar-organizer
    ]);

    # Fragments allow ports
    networking.firewall = {
      allowedUDPPorts = [ 51413 ];
      allowedTCPPorts = [ 51413 ];
    };

    environment.sessionVariables = lib.mkMerge [
      {
        GTK_THEME = "Catppuccin-Mocha-Standard-Sapphire-Dark";
      }
      (lib.mkIf config.gnome.wayland {
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland";
        MOZ_ENABLE_WAYLAND = "1";
      })
    ]; 

  };

}