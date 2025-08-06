# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, inputs, ... }:

{

  imports = [
    ./hardware-configuration.nix
  ];
  
  catppuccin = {
    accent = "sapphire";
    flavor = "mocha";
  };

  # --- Nix Settings ---

  # Optimize store
  nix.optimise.automatic = true;
  nix.settings.auto-optimise-store = true;
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  # Allow unfree packages --!

  # ---!
  system.tools.nixos-option.enable = true;

  # --- System Settings ---

  virtualisation.libvirtd.enable = true;

  # ---!
  systemd.settings.Manager = {
    DefaultLimitNOFILE = 524288;
    DefaultTimeoutStartSec = "15s";
    DefaultTimeoutStopSec = "10s";
  };
  systemd.user.extraConfig = ''
    DefaultLimitNOFILE=524288
    DefaultTimeoutStartSec=15s
    DefaultTimeoutStopSec=10s
  '';
  security.pam.loginLimits = [
    {
      domain = "*";
      item = "memlock";
      type = "-";
      value = "unlimited";
    }
    {
      domain = "*";
      item = "rtprio";
      type = "-";
      value = "99";
    }
    {
      domain = "*";
      item = "nofile";
      type = "soft";
      value = "16777216";
    }
    {
      domain = "*";
      item = "nofile";
      type = "hard";
      value = "16777216";
    }
    {
      domain = "*";
      item = "nice";
      type = "-";
      value = "-19";
    }
  ];

  # Hostname
  network.host = "the-hope";

  # Bootloader
  bootloader = {
    grub.enable = false;
    systemd-boot.enable = true;
  };

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable Security Polkit
  security.polkit.enable = true;
  services.seatd.enable = true;
  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  # Some programs need SUID wrappers, can be configured further or are started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.gnupg.dirmngr.enable = true;

  # Setup main user
  main-user.enable = true;

  # Services
  systemd.oomd.enable = true; # Out-of-Memory killer

  services = {
    # auto-cpufreq.enable = true;
    # envfs.enable = true;
    # nscd.enableNsncd = true;
    chrony.enable = true;
    fwupd.enable = true;
    udisks2.enable = true;
    dbus.implementation = "broker";
    das_watchdog.enable = lib.mkForce true;

    ollama = {
      enable = true;
      acceleration = "cuda";
      openFirewall = true;
    };
    nixai = {
      enable = true;
      mcp = {
        enable = true;
        aiProvider = "ollama";  # Options: "ollama", "gemini", "openai"
        aiModel = "gemma3";
      };
    };
    open-webui = {
      enable = false;
      openFirewall = true;
      environment = {
        OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
        ANONYMIZED_TELEMETRY = "False";
        DO_NOT_TRACK = "True";
        SCARF_NO_ANALYTICS = "True";
        # Disable authentication
        WEBUI_AUTH = "False";
      };
    };
  };

  services.journald.extraConfig = "SystemMaxUse=100M";

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
  hardware.enableRedistributableFirmware = false;

  nvidia.enable = true;

  # --- Desktop Settings ---

  # gnome.enable = false;
  # hyprland.enable = true;
  plasma.enable = true;

  # --- System wide programs ---

  environment.systemPackages = with pkgs; [

    # Utils
    teamviewer
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
    evtest
    bubblewrap
    payload-dumper-go
    nurl
    inputs.nixos-needsreboot.packages.${pkgs.system}.default

    # Dependencies
    gcc
    libgcc
    gtop
    p7zip
    # mesa-demos
    icu

    # Other
    pdm
    alpaca
    zenity
    sway
    nixd
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
        extraArgs = "--keep 3";
      };
    };

    nix-ld = {
      enable = true;
      # put whatever libraries you think you might need
      # nix-ld includes a strong sane-default as well
      # in addition to these
      libraries = with pkgs; [
        stdenv.cc.cc.lib
        zlib
      ];
    };
  };

  stylix = {
    enable = true;
    image = ../../assets/wallpapers/nix-catppuccin-alt.png;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    

    cursor = {
      name = "Simp1e-Catppuccin-Mocha";
      package = pkgs.simp1e-cursors;
      size = 24;
    };

    fonts = {
      sizes.applications = 12;
      sizes.popups = 14;
      sizes.terminal = 12;
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
