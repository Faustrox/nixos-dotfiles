{ lib, config, pkgs, ... }:

{
  options = {
    obs.enable = 
    lib.mkEnableOption "Enable obs studio";
  };

  config = lib.mkIf config.obs.enable {
      
    programs = {
      obs-studio = {
        enable = true;
        plugins = with pkgs; [
          obs-studio-plugins.obs-vkcapture
        ];
      };
    };

  };

}