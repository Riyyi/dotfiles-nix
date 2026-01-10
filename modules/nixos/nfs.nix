{
  config,
  dot,
  lib,
  ...
}:

let
  cfg = config.features.nfs;
in
{

  options.features.nfs = {
  };

  config = lib.mkIf cfg.enable {

    services.nfs = {
      server = {
        enable = true;
        exports = ''
          /mnt/data        192.168.0.0/24(rw,fsid=0,no_subtree_check)
          ${dot.code}      192.168.0.0/24(rw,nohide,insecure,no_subtree_check)
          ${dot.documents} 192.168.0.0/24(rw,nohide,insecure,no_subtree_check)
          ${dot.downloads} 192.168.0.0/24(rw,nohide,insecure,no_subtree_check)
          ${dot.games}     192.168.0.0/24(rw,nohide,insecure,no_subtree_check)
          ${dot.music}     192.168.0.0/24(rw,nohide,insecure,no_subtree_check)
          ${dot.pictures}  192.168.0.0/24(rw,nohide,insecure,no_subtree_check)
          ${dot.videos}    192.168.0.0/24(rw,nohide,insecure,no_subtree_check)
        '';
      };
    };

    features.firewall.enable = true;
    features.firewall.allowedTCPPorts = lib.mkAfter [ 2049 ];

  };

}
