{ config, lib, pkgs, inputs, ... }: let

  quantumRate = "${toString config.sound.quantum}/${toString config.sound.rate}";

in {
  
  options = {
    hardware.sound.setup =
      lib.mkEnableOption "Enables and configure sound.";
  };

  config = lib.mkIf config.hardware.sound.setup {

    environment.systemPackages = with pkgs; [
      easyeffects
      pavucontrol
      pulseaudio
      headsetcontrol
      helvum
    ];

    services.udev.packages = with pkgs; [ headsetcontrol ];

    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # jack.enable = true;
      extraConfig = {
        pipewire = {
          "92-pipewire-conf" = {
            "stream.properties" = {
              "default.clock.allowed-rates" = [ 44100 48000 96000 ];
              "default.clock.min-quantum" = 512;
              "default.clock.quantum" = 1024;
              "default.clock.max-quantum" = 1024;
            };
          };
        };
        pipewire-pulse = {
          "92-pulse-conf" = {
            "pulse.properties" = {
              "pulse.min.req" = "512/48000";
              "pulse.default.req" = "1024/48000";
              "pulse.max.req" = "1024/48000";
              "pulse.min.quantum" = "512/48000";
              "pulse.max.quantum" = "1024/48000";
            };
            "stream.properties" = {
              "node.latency" = "1024/48000";
              "resample.quality" = 1;
            };
          };
        };
      };
    };

  };

}
