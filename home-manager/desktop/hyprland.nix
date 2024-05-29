{ config, lib, pkgs, ... }:

{

  options = {
    hyprland.setup =
      lib.mkEnableOption "Enables and configure Hyprland";
  };

  config = lib.mkIf config.hyprland.setup {

  };

}
