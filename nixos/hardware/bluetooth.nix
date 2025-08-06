{ config, lib, pkgs, ... }:

{
  
  options = {
    bluetooth.enable =
      lib.mkEnableOption "Enables and configure bluetooth";
  };

  config = lib.mkIf config.bluetooth.enable {

    # Enable Bluetooth
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;

      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Privacy = "device";
          JustWorksRepairing = "always";
          Class = "0x000100";
          FastConnectable = true;
        };
        LE = {
          MinConnectionInterval = 7;
          MaxConnectionInterval = 9;
          ConnectionLatency = 0;
        };
      };
    };

    # Fix Controller

    boot.extraModprobeConfig = ''
      options hid-xpadneo ff_connect_notify=0
      options bluetooth disable_ertm=Y
      options btusb enable_autosuspend=0
    '';

    # services.blueman.enable = true;

  };

}