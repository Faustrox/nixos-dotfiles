# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{

  imports = [
    ./hardware-configuration.nix
  ];
  
  catppuccin.flavor = "mocha";

  # --- System Settings ---

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Optimize store
  nix.optimise.automatic = true;
  nix.settings.auto-optimise-store = true;

  # Network Settings
  network.host = "the-hope";

  # Enable Security Polkit
  security.polkit.enable = true;

  # Setup main user
  main-user.enable = true;

  # Set up docker for nixos
  docker.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Fragments allow ports
  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 51413 ];
    allowedTCPPorts = [ 51413 ];
  };

  # Kernel Version
  boot.kernelPackages = pkgs.linuxPackages_cachyos-lto;

  # Services
  services = {
    # Handle process when out of memory
    earlyoom.enable = true;

    ollama = {
        enable = true;
        acceleration = "cuda";
    };
    # Import udev rules
    udev.extraRules = builtins.readFile ./rules-file;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05";

  # --- Hardware Settings ---

  bluetooth.enable = true;
  hardware.sound.setup = true;

  nvidia.enable = true;

  # --- Desktop Settings ---

  gnome.enable = false;
  hyprland.enable = true;
  portals.enable = true;
  portals.extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];

  # --- System wide programs ---

  environment.systemPackages = with pkgs; [

    # Utils
    rivalcfg
    rar
    zip
    unrar
    unzip
    toybox
    git
    wget
    curl
    meson
    pkg-config
    gnumake
    cmake
    ninja
    appimage-run
    glxinfo
    zenmonitor
    lm_sensors

    # Dependencies
    gcc
    gtop
    p7zip
    mesa-demos
    vulkanPackages_latest.vulkan-tools
    vulkanPackages_latest.vulkan-headers

    # Terminal
    kitty

  ];

  security.wrappers = {
    firejail = {
      source = "${pkgs.firejail.out}/bin/firejail";
    };
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "Hack" ]; })
  ];

  programs = {
    adb.enable = true;
    firejail.enable = true;
    
    nh = {
      enable = true;
      clean.enable = true;
      flake = "/home/faustrox/.dotfiles";
    };
  };

  # --- Others Settings ---

  # Tweaks and system config for NixOs Gaming
  gaming.setup = true;

}
