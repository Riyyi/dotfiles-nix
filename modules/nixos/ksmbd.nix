{
  config,
  dot,
  lib,
  pkgs,
  ...
}:

let
  mount =
    { name, path }:
    ''
      [${name}]
        browseable = yes
        comment = Share for ${path}.
        guest ok = no
        path = ${path}
        read only = no
    '';
in
{

  options.ksmbd = {
  };

  config = lib.mkIf config.features.ksmbd {

    environment.etc."ksmbd/ksmbd.conf".text = ''
      [global]
        server string = nixos-nas KSMBD
        workgroup = WORKGROUP
        netbios name = nixos-nas
        invalid users = root
        server min protocol = SMB2_10
        smb2 leases = yes

      ${mount {
        name = "code";
        path = dot.code;
      }}
      ${mount {
        name = "documents";
        path = dot.documents;
      }}
      ${mount {
        name = "downloads";
        path = dot.downloads;
      }}
      ${mount {
        name = "games";
        path = dot.games;
      }}
      ${mount {
        name = "music";
        path = dot.music;
      }}
      ${mount {
        name = "pictures";
        path = dot.pictures;
      }}
      ${mount {
        name = "videos";
        path = dot.videos;
      }}
    '';

    environment.etc."ksmbd/ksmbdpwd.db".text = ''
      ${dot.user}:7APGued9PyGEkx+EhZUSLg==
    '';

    firewall.enable = true;
    firewall.allowedTCPPorts = lib.mkAfter [ 445 ];

    boot.kernelModules = lib.mkAfter [ "ksmbd" ];

    systemd.services.ksmbd = {
      description = "KSMBD SMB Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        Type = "forking";
        ExecStart = "${pkgs.ksmbd-tools}/bin/ksmbd.mountd";
        ExecStop = "${pkgs.ksmbd-tools}/bin/ksmbd.control --shutdown";
        Restart = "on-failure";
      };
    };

  };

}

# Docs:
# - https://github.com/cifsd-team/ksmbd-tools#usage
# - https://docs.kernel.org/filesystems/smb/ksmbd.html#how-to-run

# TODO: Generate the password .db file from activation script (?)

# Password can be set manually with:

# $ sudo ksmbd.adduser --password <password> -add <user>

# Deterministically getting the hash:

# $ echo -n "<password>" | iconv -t UTF-16LE | openssl dgst -provider legacy -md4 -binary | base64
