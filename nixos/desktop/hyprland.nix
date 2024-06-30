{ config, pkgs, lib, inputs, ... }: 

{

  options = {
    hyprland.enable = 
      lib.mkEnableOption "Enable Hyprland and configure";
  };

  config = lib.mkIf config.hyprland.enable {

    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.x86_64-linux.hyprland;
    };

    services.displayManager = { 
      sddm = {
        enable = true;
        package = pkgs.kdePackages.sddm;
        wayland.enable = true;
        catppuccin.enable = true;
      };
    };

    services.gvfs.enable = true;

    environment.systemPackages = with pkgs; [
      
      wlr-randr
      wl-clipboard
      wl-clip-persist
      networkmanagerapplet
      
    ];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      # ELECTRON_OZONE_PLATFORM_HINT = "auto";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
    };

  };

}
