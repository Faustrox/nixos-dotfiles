{ lib, ... }:

{
  imports = [
    ./grub.nix
    ./main-user.nix
    ./network.nix
    ./time.nix
    ./x11.nix
  ];

  grub.enable = lib.mkDefault true;

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
    LC_TIME = "es_DO.UTF-8";
  };

  x11.enable = lib.mkDefault true;
  x11.keymap = lib.mkDefault {
    xkb.layout = "us";
    xkb.variant = "alt-intl";
  };
  
}