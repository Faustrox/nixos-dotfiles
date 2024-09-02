{ config, lib, pkgs, ... }:

{

  options = {
    grub.enable = 
      lib.mkEnableOption "Use grub as bootloader";
  };

  config = lib.mkIf config.grub.enable {

    boot = {

      plymouth = {
        enable = true;
        catppuccin.enable = true;
      };

      # Silent boot
      consoleLogLevel = 0;
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "loglevel=3"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
        "bgrt_disable" # Disable OEM Logo on system startup loading screen
        "retbleed=off"
        "mitigations=off"
      ];
      initrd.verbose = false;

      # Bootloader config
      loader = {
        efi.canTouchEfiVariables = true;
        timeout = 3;
        grub = {
          enable = true;
          gfxmodeEfi = "1920x1080";
          devices = [ "nodev" ];
          efiSupport = true;
          useOSProber = false;
          default = 0;
          catppuccin.enable = true;
        };
      };
    };

  };
  
}