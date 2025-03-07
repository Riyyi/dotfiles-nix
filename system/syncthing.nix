{ config, pkgs, dot, ... }:

{

  services.syncthing = {
    enable = true;
    user = dot.user;
    group = dot.group;
    openDefaultPorts = true; # TCP/UDP 22000, UDP 21027
    # Optional: GUI credentials (can be set in the browser instead if you don't want plaintext credentials in your configuration.nix file)
    # or the password hash can be generated with "syncthing generate --config <path> --gui-password=<password>"
    settings.gui = {
      address = "0.0.0.0:8384"; # enable remote access
      user = "myuser";
      password = "mypassword";
    };
  };

}

# FIXME:
# - sudo mkdir /var/lib/syncthing
# - sudo chown -R rick:users /var/lib/syncthing
