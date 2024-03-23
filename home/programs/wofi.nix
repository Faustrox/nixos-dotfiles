{ config, lib, ... }:

{

  options = {
    wofi.setup =
      lib.mkEnableOption "Enables and configure Wofi";
  };

  config = lib.mkIf config.wofi.setup {

    programs.wofi.enable = true;

    home.file = {
      ".config/wofi".source = ../config/wofi;
    };

  };

}
