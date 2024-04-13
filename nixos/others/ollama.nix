{ config, lib, pkgs, ... }:

{

  options = {
    ollama.enable = 
      lib.mkEnableOption "Enable and setup Ollama";
    ollama.acceleration = lib.mkOption {
      default = "cuda";
      description = "Specifies the interface to use for hardware acceleration";
    };
    # open-webui.enable = 
    # lib.mkEnableOption "Enable and setup open-webui for ollama";
  };

  config = lib.mkMerge [
    (lib.mkIf config.ollama.enable {

      services.ollama = {
        enable = true;
        acceleration = config.ollama.acceleration;
      };
      
    })
  ];

}