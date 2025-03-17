let
  zfsDisk = { device }: {
    device = "/dev/disk/by-id/${device}";
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        zfs = {
          size = "100%";
          content = {
            type = "zfs";
            pool = "znas";
          };
        };
      };
    };
  };
in
{

  disko.devices = {
    disk = {
      nas1 = zfsDisk { device = "ata-HGST_HUS726T6TALE6L4_V8J0R94R"; };
      nas2 = zfsDisk { device = "ata-HGST_HUS726T6TALE6L4_V9H5Z5UR"; };
      nas3 = zfsDisk { device = "ata-HGST_HUS726T6TALE6L4_V9HE0RVL"; };
      nas4 = zfsDisk { device = "ata-HGST_HUS726T6TALE6L4_V9JGPU5L"; };
    };
    zpool = {
      znas = {
        type = "zpool";
        mode = "raidz1";

        # Pool level options (how youre storing)
        options = {
          ashift = "12";           # set 4KB block size
        };
        # Filesystem level options (what/when youre storing)
        rootFsOptions = {
          acltype = "posixacl";
          atime = "off";           # disable access time updates for performance
          compression = "lz4";     # enable compression
          mountpoint = "none";
          recordsize = "1M";       # optimize size for large file workloads
          secondarycache = "none"; # disable L2ARC
          xattr = "sa";            # set metadata directly in inodes, over separate hidden files
          "com.sun:auto-snapshot" = "true";
        };

        datasets = {
          dataset = {
            type = "zfs_fs";
            mountpoint = "/mnt/nas";
            options.canmount = "on";
          };
        };
      };
    };
  };

}
