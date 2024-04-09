{ config, lib, pkgs, ... }:

{

  options = {
    plasma.enable = 
      lib.mkEnableOption "Enable and configure Plasma";
    plasma6.enable = 
      lib.mkEnableOption "Enable Plasma 6";
    plasma6.forceX11 =
      lib.mkEnableOption "Force X11 to plasma";
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
          theme = "catppuccin-sddm-corners";
        };
        services.xserver.displayManager.defaultSession = 
        if config.plasma6.forceX11 
          then "plasmax11" 
        else "plasma";
        
        services.xserver.desktopManager.plasma5.enable = !config.plasma6.enable;
        services.desktopManager.plasma6.enable = config.plasma6.enable;


        # Enable the Plasma 6 Dekstop Environment.
        services.xserver.displayManager.sddm.wayland.enable = 
        if config.plasma6.forceX11 
          then false 
        else 
          if config.plasma6.enable 
            then true
        else false;

        environment.systemPackages = with pkgs; [
            plasmaPkgs.partitionmanager
            plasmaPkgs.ktorrent
          ];

      }
    )
    (lib.mkIf config.plasma6.enable {
        environment.sessionVariables = 
        if config.plasma6.forceX11 
        then {} 
        else {
          NIXOS_OZONE_WL = "1";
          QT_QPA_PLATFORM = "wayland";
          MOZ_ENABLE_WAYLAND = "1";
        };
      }
    )
    (lib.mkIf config.kwallet.enable {
      # Set up KDE Wallet 
      security.pam.services.kwallet = {
        name = "kwallet";
        enableKwallet = true;
      };
    })
  ];

}