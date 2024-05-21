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
      headsetcontrol
      helvum
    ];

    services.udev.packages = with pkgs; [ headsetcontrol ];

    sound.enable = false;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # jack.enable = true;
      wireplumber = {
        enable = true;
        configPackages = [
          (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/alsa.conf" ''
            monitor.alsa.rules = [
              {
                matches = [
                  {
                    device.name = "~alsa_card.*"
                  }
                ]
                actions = {
                  update-props = {
                    # Device settings
                    api.alsa.use-acp = true
                  }
                }
              }
              {
                matches = [
                  {
                    node.name = "alsa_output.usb-SteelSeries_Arctis_Nova_7-00.analog-stereo"
                  }
                ]
                actions = {
                # Node settings
                  update-props = {
                    audio.format = "S24LE"
                    audio.rate = "96000"
                    api.alsa.disable-batch = true
                    session.suspend-timeout-seconds = 0
                    api.alsa.period-size   = 256
                    api.alsa.headroom      = 1024
                  }
                }
              }
            ]
          '')
        ];
      };
      extraConfig = {
        pipewire = {
          "92-pipewire-conf" = {
            "stream.properties" = {
              "default.clock.allowed-rates" = [ 44100 48000 82000 96000 ];
              "default.clock.min-quantum" = 32;
              "default.clock.quantum" = 1024;
              "default.clock.max-quantum" = 2048;
            };
          };
        };
        pipewire-pulse = {
          "92-pulse-conf" = {
            "pulse.properties" = {
              "pulse.min.req" = "32/48000";
              "pulse.default.req" = "1024/48000";
              "pulse.min.frag" = "32/48000";
              "pulse.default.frag" = "1024/48000";
              "pulse.default.tlength" = "1024/48000";
              "pulse.min.quantum" = "128/48000";
              # "pulse.default.format"   = S24;
            };
            "stream.properties" = {
              "node.latency" = "32/48000";
              "resample.quality" = 1;
            };
          };
        };
      };
    };

  };

}
