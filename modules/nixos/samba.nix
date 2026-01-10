{
  config,
  dot,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features.samba;

  mount =
    { path }:
    {
      browseable = "yes";
      comment = "Share for ${path}.";
      "guest ok" = "no";
      path = path;
      "read only" = "no";
    };
in
{

  options.features.samba = {
  };

  config = lib.mkIf cfg.enable {

    sops.secrets."samba/user/password" = {
      owner = "root";
    };

    services.samba = {
      enable = true;
      package = pkgs.samba4Full;

      # https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "hosts allow" = "192.168.0. 127.0.0.1 localhost"; # localhost = ::1
          "hosts deny" = "0.0.0.0/0";
          "invalid users" = [
            "root"
          ];
          "passwd program" = "/run/wrappers/bin/passwd %u";
          security = "user";
        };

        code = mount { path = dot.code; };
        documents = mount { path = dot.documents; };
        downloads = mount { path = dot.downloads; };
        games = mount { path = dot.games; };
        music = mount { path = dot.music; };
        pictures = mount { path = dot.pictures; };
        videos = mount { path = dot.videos; };
      };
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      publish.enable = true;
      publish.userServices = true; # auto register mDNS records
    };

    # Enable autodiscovery on Windows
    services.samba-wsdd = {
      enable = true;
    };

    features.firewall.enable = true; # samba     avahi  wsdd
    features.firewall.allowedTCPPorts = lib.mkAfter [
      139
      445
      5357
    ];
    features.firewall.allowedUDPPorts = lib.mkAfter [
      137
      138
      5353
      3702
    ];

    # Activate default user
    # To remove the user: $ smbpasswd -x <user>
    system.activationScripts.samba = ''
      if ! ${pkgs.samba}/bin/pdbedit -L | grep -q '^${dot.user}:'; then
        passwd="$(cat ${config.sops.secrets."samba/user/password".path})";
        (echo "$passwd"; echo "$passwd") | ${pkgs.samba}/bin/smbpasswd -s -a ${dot.user}
      fi
    '';

  };

}

# $ smbpasswd -a dot.user
