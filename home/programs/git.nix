{ config, lib, pkgs, ... }:

{
  
  options = {
    git.enable = 
      lib.mkEnableOption "Enables and configure git";
    git.userName = 
      lib.mkOption {
        default = "Fausto Jáquez";
        description = "git username";
      };
    git.userEmail = 
      lib.mkOption {
        default = "Faustojr03@gmail.com";
        description = "git email";
      };
  };

  config = lib.mkIf config.git.enable {

    programs.git = {
      enable = true;
      userName  = config.git.userName;
      userEmail = config.git.userEmail;
      aliases = {
        a = "add";
        cm = "commit -m";
        ck = "checkout";
        l = "log --oneline";  
        s = "status";
        st = "stash";
      };
    };

  };

}