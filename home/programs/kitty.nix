{ config, lib, pkgs, ... }:

{
  
  options = {
    kitty.setup = lib.mkEnableOption "Enables and configure kitty";
    kitty.theme = lib.mkOption {
      default = "Catppuccin-Mocha";
      description = "Kitty theme to use"; 
    };
  };

  config = lib.mkIf config.kitty.setup {

    home.packages = with pkgs; [
      kitty
    ];

    # Theming with programs.kitty.theme do not theme titlebar in Wayland
    # programs.kitty = {
    #   enable = true;
    #   theme = config.kitty.theme;
    # };

  };

}