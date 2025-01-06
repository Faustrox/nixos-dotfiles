{ config, lib, pkgs, inputs, ... }: let

  quantumRate = "${toString config.sound.quantum}/${toString config.sound.rate}";

in {
  
  options = {
    hardware.sound.setup =
      lib.mkEnableOption "Enables and configure sound.";
  };

  config = lib.mkIf config.hardware.sound.setup {

    environment.systemPackages = with pkgs; [
      pavucontrol
      headsetcontrol
    ];

    programs.noisetorch.enable = true;

    services.udev.packages = with pkgs; [ headsetcontrol ];

    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # jack.enable = true;
      wireplumber.extraConfig = {
        "92-wireplumber" = {
          "monitor.alsa.rules" = [
            {
              matches = [
                {
                  "device.name" = "alsa_card.usb-SteelSeries_Arctis_Nova_7-00";
                }
              ];
              actions = {
                "update-props" = {
                  # "device.profile" = "pro-audio";
                  "api.alsa.period-size" = 64;
                  "api.alsa.period-num" = 3;
                  "audio.rate" = 48000;
                };
              };
            }
          ];
        };
      };
      extraConfig = {
        pipewire = {
          "92-pipewire" = {
            "stream.properties" = {
              "default.clock.rate" = 48000;
              "default.clock.allowed-rates" = [ 32000 44100 48000 ];
              "default.clock.min-quantum" = 32;
              "default.clock.quantum" = 64;
              "default.clock.max-quantum" = 64;
              "default.clock.quantum-limit" = 64;
            };
          };
        };
        pipewire-pulse = {
          "92-pulse" = {
            "pulse.properties" = {
              "pulse.min.req" = "64/48000";
              "pulse.default.req" = "64/48000";
              # "pulse.max.req" = "1024/48000";
              "pulse.min.quantum" = "64/48000";
              # "pulse.max.quantum" = "1024/48000";
            };
            "stream.properties" = {
              "node.latency" = "1024/48000";
              "resample.quality" = 1;
            };
            "context.modules" = [
              {
                name = "libpipewire-module-rt";
                args = {
                  "nice.level" = -20;
                  "rt.prio" = 99;
                };
              }
            ];
          };
        };
        # jack = {
        #   "92-jack-conf" = {
        #     "node.latency" = "64/48000";
        #     "node.quantum" = "64/48000";
        #   }
        # };
      };
    };

  };

}
