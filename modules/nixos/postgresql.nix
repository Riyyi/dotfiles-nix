{
  config,
  dot,
  lib,
  pkgs,
  ...
}:

{
  options.postgresql = {
    databases = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of database names needed by services";
    };
  };

  config = lib.mkIf config.features.postgresql {

    sops.secrets."postgres/database/password" = {
      owner = "postgres";
    };

    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_16;
      authentication = pkgs.lib.mkForce ''
        # TYPE     DATABASE    USER     ADDRESS           AUTH-METHOD
          local    all         all                        peer
          host     all         all      127.0.0.1/32      md5
          host     all         all      ::1/128           md5
      '';

      ensureDatabases = config.postgresql.databases;
      ensureUsers = lib.map (db: {
        name = db;
        ensureDBOwnership = true;
      }) config.postgresql.databases;

      dataDir = "${dot.config}/postgresql/${config.services.postgresql.package.psqlSchema}";
    };

    services.postgresqlBackup = {
      enable = true;
      location = "${dot.documents}/backup/${dot.hostname}/postgresql";
      backupAll = true; # mutually exclusive with "databases" []
      startAt = "*-*-* 01:00:00"; # every day at 01:00 AM, see systemd.time
      compression = "gzip";
      compressionLevel = 6; # 1-9 for gzip, 1-19 for zstd
    };

    firewall.enable = true;
    firewall.allowedTCPPorts = lib.mkAfter [ 5432 ];
    firewall.allowedUDPPorts = lib.mkAfter [ 5432 ];

    system.activationScripts.postgresql = ''
      dataDir="${dot.config}/postgresql"
      mkdir -p $dataDir/${config.services.postgresql.package.psqlSchema}
      chown -R postgres:postgres $dataDir # fix initial directory creation

      passwd="$(cat ${config.sops.secrets."postgres/database/password".path})";
      runuser -u postgres -- ${pkgs.postgresql}/bin/psql -c "ALTER USER postgres WITH PASSWORD '$passwd';"
    '';

  };

}

# sudo -u postgres psql
