{ config, lib, ... }:

{
  
  options = {
    time.enable = 
      lib.mkEnableOption "Enables and configure time";
    time.zone = 
      lib.mkOption {
        description = "timezone";
      };
    time.defaultLocale = 
      lib.mkOption {
        description = "Default locale";
      };
    time.extraLocale = 
      lib.mkOption {
        description = "Extra locale";
      };
    x11.keymap = 
      lib.mkOption {
        description = "Keymap";
      };
  };

  config = lib.mkIf config.time.enable {
    # Set your time zone.
    time.timeZone = config.time.zone;

    # Fix for dual boot windows
    time.hardwareClockInLocalTime = true;

    # Select internationalisation properties.
    i18n.defaultLocale = config.time.defaultLocale;

    i18n.extraLocaleSettings = config.time.extraLocale;

    # Configure keymap in X11
    services.xserver = config.x11.keymap;
  };

}
