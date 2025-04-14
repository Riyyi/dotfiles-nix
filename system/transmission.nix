{ config, pkgs, lib, dot, ... }:

{

	options.transmission = {
    enable = lib.mkEnableOption "transmission";
  };

  config = lib.mkIf config.transmission.enable {

    services.transmission = {
      enable = true;
      user = dot.user;
      group = dot.group;
      home = "${dot.config}/transmission";
      openRPCPort = false; # web access via nginx
      openPeerPorts = true;
      package = pkgs.transmission_4;
      settings = {
        rpc-bind-address = "0.0.0.0";
        rpc-whitelist = "*";
        rpc-whitelist-enabled = true;
        rpc-host-whitelist = "*";
        rpc-host-whitelist-enabled = true;
        download-dir = "${dot.downloads}";
        incomplete-dir = "${dot.downloads}/.incomplete";
      };
    };

    system.activationScripts.transmission = ''
      configDir="${config.services.transmission.home}/.config/transmission-daemon"
      mkdir -p $configDir
      chown -R ${dot.user}:${dot.group} $configDir # fix initial directory creation

      incompleteDir="${config.services.transmission.settings.incomplete-dir}"
      mkdir -p $incompleteDir
      chown -R ${dot.user}:${dot.group} $incompleteDir # fix initial directory creation
    '';

  };

}
