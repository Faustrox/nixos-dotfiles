{ config, lib, ... }:

{
  
  options = {
    bluetooth.enable =
      lib.mkEnableOption "Enables and configure bluetooth";
  };

  config = lib.mkIf config.bluetooth.enable {

    # Enable Bluetooth
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

  };

}