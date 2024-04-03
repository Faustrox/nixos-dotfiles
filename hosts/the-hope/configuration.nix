# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Network and Time settings
  network.host = "the-hope";

  time.zone = "America/Santo_Domingo";
  time.defaultLocale = "en_US.UTF-8";
  time.extraLocale = {
    LC_ADDRESS = "es_DO.UTF-8";
    LC_IDENTIFICATION = "es_DO.UTF-8";
    LC_MEASUREMENT = "es_DO.UTF-8";
    LC_MONETARY = "es_DO.UTF-8";
    LC_NAME = "es_DO.UTF-8";
    LC_NUMERIC = "es_DO.UTF-8";
    LC_PAPER = "es_DO.UTF-8";
    LC_TELEPHONE = "es_DO.UTF-8";
    LC_TIME = "es_DO.UTF-8";
  };
  x11.keymap = {
    xkb.layout = "us";
    xkb.variant = "alt-intl";
  };

  # Enable Security Polkit
  security.polkit.enable = true;

  # Nvidia open drivers
  nvidia.open = true;

  # Force X11 and disable Wayland for plasma 6
  plasma.forceX11 = false;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Tweaks and system config for NixOs Gaming
  gaming.setup = true;

  main-user.enable = true;
  main-user.userName = "faustrox";

  # Set up docker for nixos
  docker.enable = true;
  docker.userName = "faustrox";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  services.fstrim.enable = lib.mkDefault true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [

    # Utils
    p7zip
    rar
    zip
    unrar
    unzip
    toybox
    mesa-demos
    vulkan-tools
    appimage-run
    git
    wget
    curl
    kdePackages.partitionmanager
    kdePackages.ktorrent
    # gnome.gnome-tweaks
    _1password
    _1password-gui

    # Fonts
    (nerdfonts.override { fonts = [ "FiraCode" "Hack" ]; })

    # Others
    bat
    fzf
    neofetch
    glxinfo

  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
