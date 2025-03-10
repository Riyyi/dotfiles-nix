{ config, pkgs, ... }:

let
	user = "syncthing";
  group = "syncthing";
in
{

  users.users.${user} = {
    isSystemUser = true;
    group = group;
  };
  users.groups.${group} = {};

  sops.secrets."syncthing/gui/password" = {
    owner = user;
  };

  services.syncthing = {
    enable = true;
    user = user;
    group = group;
    openDefaultPorts = true; # TCP/UDP 22000, UDP 21027
    settings.gui = {
      address = "0.0.0.0:8384"; # enable remote access
      user = "Riyyi";
      # password = "placeholder";
    };
  };

  system.activationScripts.syncthing = ''
    dataDir="${config.services.syncthing.dataDir}"
    chown -R ${user}:${group} $dataDir # fix initial directory creation
  '';

  # system.activationScripts.syncthing = ''
  #   dataDir="${config.services.syncthing.dataDir}"
  #   configDir="${config.services.syncthing.configDir}"

  #   secret=$(cat '${config.sops.secrets."syncthing/gui/password".path}')
  #   ${pkgs.sudo}/bin/sudo -u ${user} HOME="$dataDir" ${pkgs.syncthing}/bin/syncthing generate \
  #     --config $configDir --gui-user=Riyyi --gui-password=$secret
  #   chown ${user}:${group} "$configDir/config.xml" # config generation recreates the file

  #   secret=$(cat '${config.sops.secrets."syncthing/gui/password".path}')
  #   hash=$(${pkgs.apacheHttpd}/bin/htpasswd -bnBC 10 "" "$secret" | tr -d ':\n')
  #   ${pkgs.gnused}/bin/sed -Ei "s|(<password>).*(</password>)|\1$hash\2|" "$configDir/config.xml"
  # '';

  #   systemd.services.syncthing-set-password = {
  #     enable = false;
  #     description = "Set Syncthing password";
  #     wantedBy = [ "multi-user.target" ];
  #     unitConfig.After = "syncthing.service";
  #     serviceConfig.Type = "oneshot";
  #     script = ''
  #       dataDir="${config.services.syncthing.dataDir}"
  #       configDir="${config.services.syncthing.configDir}"

  #       secret=$(cat '${config.sops.secrets."syncthing/gui/password".path}')
  #       apikey=$(${pkgs.gnused}/bin/sed -nE 's|\s*<apikey>(.*)</apikey>|\1|p' "$configDir/config.xml")
  #       ${pkgs.curl}/bin/curl -X PATCH -H "X-API-Key: $apikey" -d "{ \"password\": \"$secret\" }" http://localhost:8384/rest/config/gui
  #     '';
  #     serviceConfig.RemainAfterExit = true;  # Keep the service as 'active' after completion
  #   };

}

  # FIXME:
  # - sudo mkdir /var/lib/syncthing
  # - sudo chown -R rick:users /var/lib/syncthing
