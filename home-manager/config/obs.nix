{ lib, config, pkg, ... }:

{
  options = {
    obs.enable = 
    lib.mkEnableOption "Enable obs studio";
  };

  config = lib.mkIf config.obs.enable {
      
    programs = {
      obs-studio = {
        enable = true;
      };
    };

  };

}