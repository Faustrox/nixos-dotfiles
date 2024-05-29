{ config, pkgs, lib, inputs, ... }: 

{

  options = {
    hyprland.enable = 
      lib.mkEnableOption "Enable Hyprland and configure";
  };

  config = lib.mkIf config.hyprland.enable {

    nix.settings = {
      substituters = lib.mkBefore [ "https://hyprland.cachix.org" ];
      trusted-public-keys = lib.mkBefore [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.x86_64-linux.hyprland;
    };

    services.xserver.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "catppuccin-sddm-corners";
    };

    environment.systemPackages = with pkgs; [

      copyq
      wl-clipboard
      cliphist
      grim
      slurp
      gnome.nautilus
      dunst
      libnotify
      swww
      rofi-wayland
      networkmanagerapplet
      catppuccin-sddm-corners
      
    ];

    environment.sessionVariables = {
      # NIXOS_OZONE_WL = "1";
      # ELECTRON_OZONE_PLATFORM_HINT = "auto";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
    };

  };

}
