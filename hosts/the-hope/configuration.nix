# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{

  imports = [
    ./hardware-configuration.nix
  ];
  
  catppuccin.flavor = "mocha";

  # Register AppImage files as a binary type to binfmt_misc
  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Optimize store
  nix.optimise.automatic = true;
  nix.settings.auto-optimise-store = true;

  # Network Settings
  network.host = "the-hope";

  # Enable Security Polkit
  security.polkit.enable = true;

  # Enable Plasma 6
  # plasma6.enable = true;
  # plasma6.wayland = false;

  # Enable Gnome
  gnome.enable = false;
  gnome.wayland = false;
  
  hyprland.enable = true;
  portals.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Tweaks and system config for NixOs Gaming
  gaming.setup = true;

  # Setup main user
  main-user.enable = true;

  # Set up docker for nixos
  docker.enable = true;

  # Ollama Setup
  ollama.enable = true;
  # open-webui.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Recommended for SSD
  services.fstrim.enable = true;

  # Fragments allow ports
  networking.firewall = {
    allowedUDPPorts = [ 51413 ];
    allowedTCPPorts = [ 51413 ];
  };

  # List packages installed in system profile. To search, run:
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
    cmake
    ninja
    _1password
    _1password-gui
    appimage-run
    bat
    fzf
    fastfetch
    glxinfo
    nh
    zenmonitor

    # Dependencies
    gcc
    gtop
    p7zip
    mesa-demos
    vulkan-tools

  ];

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "Hack" ]; })
  ];

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep 3";
    flake = "/home/faustrox/.dotfiles";
  };

  services.udev.extraRules = builtins.readFile ./rules-file;

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
