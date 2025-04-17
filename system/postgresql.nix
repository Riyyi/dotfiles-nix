{ config, pkgs, lib, dot, ... }:

{
  options.postgresql = {
    enable = lib.mkEnableOption "postgresql";
    databases = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of database names needed by services";
    };
  };

  config = lib.mkIf config.postgresql.enable {

    services.postgresql = {
      enable = true;
      package = pkgs.postgresql;
      authentication = pkgs.lib.mkOverride 10 ''
        #type database  DBuser  auth-method
        local all       all     trust
      '';

      ensureDatabases = config.postgresql.databases;
      ensureUsers = lib.map (db: {
        name = db;
        ensureDBOwnership = true;
      }) config.postgresql.databases;

      dataDir = "${dot.config}/postgresql/${config.services.postgresql.package.psqlSchema}";
    };

    networking.firewall.allowedTCPPorts = lib.mkAfter [ 5432 ];
    networking.firewall.allowedUDPPorts = lib.mkAfter [ 5432 ];

    system.activationScripts.postgresql = ''
      dataDir="${dot.config}/postgresql"
      mkdir -p $dataDir/${config.services.postgresql.package.psqlSchema}
      chown -R postgres:postgres $dataDir # fix initial directory creation
    '';

  };

}

# sudo -u postgres psql
