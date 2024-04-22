{ config, lib, pkgs, inputs, ... }:

{

  options = {
    plasma.enable = 
      lib.mkEnableOption "Enable and configure Plasma";
    plasma6.enable = 
      lib.mkEnableOption "Enable Plasma 6";
    plasma6.wayland =
      lib.mkEnableOption "Enable Wayland on Plasma 6 and sddm";
    kwallet.enable = 
      lib.mkEnableOption "Enable and configure Kwallet";
  };

  config = let
    plasmaPkgs = 
      if config.plasma6.enable
        then pkgs.kdePackages
      else pkgs.libsForQt5;
  in lib.mkMerge [
    (lib.mkIf config.plasma.enable {
        
      services.xserver.displayManager.sddm = {
        enable = true;
        settings = {
          Theme = {
            Current = "catppuccin-mocha";
            ThemeDir = "/sddm-themes";
          };
        };
      };

      services.xserver.displayManager.defaultSession = 
      if config.plasma6.wayland 
        then "plasma" 
      else "plasmax11";
      
      services.xserver.desktopManager.plasma5.enable = !config.plasma6.enable;
      services.desktopManager.plasma6.enable = config.plasma6.enable;

      # Enable the Plasma 6 Dekstop Environment.
      services.xserver.displayManager.sddm.wayland.enable = 
      if config.plasma6.wayland 
        then if config.plasma6.enable 
          then true 
        else false
      else false;

      security.pam.services.kwallet = {
        name = "kwallet";
        enableKwallet = true;
      };

      environment.systemPackages = with pkgs; [
        plasmaPkgs.partitionmanager
        plasmaPkgs.ktorrent
        kdePackages.sddm-kcm
      ];

      environment.sessionVariables = lib.mkIf config.plasma6.wayland {
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland";
        MOZ_ENABLE_WAYLAND = "1";
      };

    })
  ];

}