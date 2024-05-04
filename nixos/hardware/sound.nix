{ config, lib, pkgs, ... }: let

  quantumRate = "${toString config.sound.quantum}/${toString config.sound.rate}";

in {
  
  options = {
    sound.setup =
      lib.mkEnableOption "Enables and configure sound.";
  };

  config = lib.mkIf config.sound.setup {

    programs.noisetorch.enable = true;   
    environment.systemPackages = with pkgs; [
      pavucontrol
    ];

    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

  };

}
