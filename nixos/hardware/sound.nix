{ config, lib, pkgs, inputs, ... }:

{

  options = {
    hardware.sound.setup =
      lib.mkEnableOption "Enables and configure sound.";
  };

  config = lib.mkIf config.hardware.sound.setup {

    environment.systemPackages = with pkgs; [
      pavucontrol
      headsetcontrol
      easyeffects
    ];

    programs.noisetorch.enable = false;

    services.udev = {
      extraRules = ''
        # This is for real time audio
        KERNEL=="rtc0", GROUP="audio"
        KERNEL=="hpet", GROUP="audio"
        KERNEL=="cpu_dma_latency", GROUP="audio"
        DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"
      '';
      packages = with pkgs; [ headsetcontrol ];
    };

    security.rtkit = {
      enable = true;
      args = [
        "--scheduling-policy=FIFO"
        "--our-realtime-priority=89"
        "--max-realtime-priority=88"
        "--min-nice-level=-19"
        "--rttime-usec-max=2000000"
        "--users-max=100"
        "--processes-per-user-max=1000"
        "--threads-per-user-max=10000"
        "--actions-burst-sec=10"
        "--actions-per-burst-max=1000"
        "--canary-cheep-msec=30000"
        "--canary-watchdog-msec=60000"
      ];
    };

    services = {
      pulseaudio.enable = false;
      
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        extraConfig.pipewire = {
          "10-clock-rate" = {
            "context.properties" = {
              "default.clock.rate" = 96000;
              "defautlt.allowed-rates" = [ 48000 88200 96000 192000 ];
              "default.clock.quantum" = 128;
              "default.clock.min-quantum" = 64;
              "default.clock.max-quantum" = 256;
            };
          };
          # "99-input-denoising.conf" = {
          #   "context.properties" = {
          #     "link.max-buffers" = 16;
          #     "core.daemon" = true;
          #     "core.name" = "pipewire-0";
          #     "module.x11.bell" = false;
          #     "module.access" = true;
          #     "module.jackdbus-detect" = false;
          #   };
          #   "context.modules" = [
          #     {
          #       "name" = "libpipewire-module-filter-chain";
          #       "args" = {
          #         "node.description" =  "Noise Canceling source";
          #         "media.name" =  "Noise Canceling source";
          #         "filter.graph" = {
          #           "nodes" = [
          #             {
          #               "type" = "ladspa";
          #               "name" = "rnnoise";
          #               "plugin" = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
          #               "label" = "noise_suppressor_stereo";
          #               "control" = {
          #                 "VAD Threshold (%)" = 50.0;
          #                 # "VAD Grace Period (ms)" = 200;
          #                 # "Retroactive VAD Grace (ms)" = 0;
          #               };
          #             }
          #           ];
          #         };
          #         "capture.props" = {
          #             "node.passive" = true;
          #             # "node.name" =  "effect_input.rnnoise";
          #             # "audio.rate" = 48000;
          #         };
          #         "playback.props" = {
          #             "media.class" = "Audio/Source";
          #             # "node.name" =  "effect_output.rnnoise";
          #             # "audio.rate" = 48000;
          #         };
          #       };
          #     }
          #   ];
          # };
        };
      };
    };
  };
}
