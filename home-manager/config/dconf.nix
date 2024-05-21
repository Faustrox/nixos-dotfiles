{ config, lib, pkgs, ... }:

{

  options = {
    dconf.setup =
      lib.mkEnableOption "Enables and configure dconf";
    dconf.colorScheme = 
      lib.mkOption {
        default = "prefer-dark";
        description = "Color scheme";
      };
  };

  config = lib.mkIf config.dconf.setup {

    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = config.dconf.colorScheme;
        };
        "org/gnome/mutter" = {
          experimental-features = [ "variable-refresh-rate" ];
        };
      };
    };

  };

}
