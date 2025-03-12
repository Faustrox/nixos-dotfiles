{ lib, ... }:

{
  imports = [
    ./bootloader.nix
    ./main-user.nix
    ./network.nix
    ./time.nix
    ./xserver.nix
  ];

  bootloader = {
    enable = lib.mkDefault true;
    grub.enable = lib.mkDefault true;
  };

  network.enable = lib.mkDefault true;
  time.enable = lib.mkDefault true;
  time.zone = lib.mkDefault "America/Santo_Domingo";
  time.defaultLocale = lib.mkDefault "en_US.UTF-8";
  time.extraLocale = lib.mkDefault {
    LC_ADDRESS = "es_DO.UTF-8";
    LC_IDENTIFICATION = "es_DO.UTF-8";
    LC_MEASUREMENT = "es_DO.UTF-8";
    LC_MONETARY = "es_DO.UTF-8";
    LC_NAME = "es_DO.UTF-8";
    LC_NUMERIC = "es_DO.UTF-8";
    LC_PAPER = "es_DO.UTF-8";
    LC_TELEPHONE = "es_DO.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  xserver.enable = lib.mkDefault true;
  xserver.keymap = lib.mkDefault {
    layout = "us";
    variant = "alt-intl";
  };
  
}