{ config, lib, ... }:

{

  options.jankyborders = {
    enable = lib.mkEnableOption "jankyborders";
  };

  config = lib.mkIf config.jankyborders.enable {

    services.jankyborders = {
      enable = true;
      settings = {
        style="round";
              width=6.0;
              hidpi="on";
              #active_color="0xff404552";
              #inactive_color="0xff2b2e39";
              active_color="0xff7a8290";
              inactive_color="0xff393d49";
      };
    };

  };

}
