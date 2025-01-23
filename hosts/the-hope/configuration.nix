# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{

  imports = [
    ./hardware-configuration.nix
  ];
  
  catppuccin.flavor = "mocha";

  # --- Nix Settings ---

  # Optimize store
  nix.optimise.automatic = true;
  nix.settings.auto-optimise-store = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  system.tools.nixos-option.enable = false;

  # --- System Settings ---

  virt-machine.enable = false;

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Network Settings
  network.host = "the-hope";

  # Enable Security Polkit
  security.polkit.enable = true;

  # Setup main user
  main-user.enable = true;

  # Set up docker for nixos
  docker.enable = false;

  # Services
  services = {
    # Handle process when out of memory
    earlyoom.enable = true;

    # help balance the cpu load generated
    irqbalance.enable = true;

    ollama = {
      enable = false;
      acceleration = "cuda";
    };
    # open-webui = {
    #   enable = true;
    #   openFirewall = true;
    #   environment = {
    #     OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
    #     ANONYMIZED_TELEMETRY = "False";
    #     DO_NOT_TRACK = "True";
    #     SCARF_NO_ANALYTICS = "True";
    #   };
    # };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05";

  # --- Hardware Settings ---

  bluetooth.enable = false;
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
    hwloc
    rivalcfg
    rar
    zip
    unrar
    unzip
    pciutils
    git
    wget
    curl
    meson
    pkg-config
    gnumake
    cmake
    ninja
    glxinfo
    zenmonitor
    lm_sensors
    killall

    # Dependencies
    gcc
    libgcc
    gtop
    p7zip
    mesa-demos

    # Terminal
    kitty

    # Other
    zenity
    sway

    cpuset

  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.hack
  ];

  programs = {
    adb.enable = true;
    dconf.enable = true;
    firejail.enable = true;

    appimage = {
      enable = true;
      binfmt = true;
    };
    
    nh = {
      enable = true;
      flake = "/home/${config.main-user.username}/.dotfiles";
      clean = {
        enable = true;
        dates = "daily";
        extraArgs = "--keep 5";
      };
    };
  };

  stylix = {
    enable = true;
    image = ../../assets/wallpapers/nix-black-4k.png;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    

    cursor = {
      name = "catppuccin-mocha-dark-cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 32;
    };

    fonts = {
      sizes.popups = 14;
      monospace = {
        package = pkgs.nerd-fonts.ubuntu-sans;
        name = "UbuntuSans Nerd Font";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.ubuntu-sans;
        name = "UbuntuSans Nerd Font";
      };
    };
  };

  # --- Others Settings ---

  # Tweaks and system config for NixOs Gaming
  gaming.setup = true;

}
