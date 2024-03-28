{ config, lib, pkgs, ... }:

{
  
  options = {
    main-user.enable =
      lib.mkEnableOption "Enables main user";
    main-user.userName = lib.mkOption {
      description = ''
        username
      '';
    };
  };

  config = lib.mkIf config.main-user.enable {

    # Set up user
    users.users.${config.main-user.userName} = {
      isNormalUser = true;
      description = "main user";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
    };

    # Enable automatic login for the user.
    services.xserver.displayManager.autoLogin.enable = true;
    services.xserver.displayManager.autoLogin.user = config.main-user.userName;

    # System programs config
    programs = {
      zsh.enable = true;

      _1password.enable = true;
      _1password-gui = {
        enable = true;
        polkitPolicyOwners = [ "faustrox" ];
      };
    };

  };

}