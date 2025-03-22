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
      nas1 = zfsDisk { device = "wwn-0x5000cca098dc82b3"; };
      nas2 = zfsDisk { device = "wwn-0x5000cca0bdd0ceae"; };
      nas3 = zfsDisk { device = "wwn-0x5000cca0bdd40318"; };
      nas4 = zfsDisk { device = "wwn-0x5000cca0bde2de15"; };
    };
    zpool = {
      znas = {
        type = "zpool";
        mode = {
          topology = {
            type = "topology";
            vdev = [
              {
                mode = "raidz1";
                members = [ "nas1" "nas2" "nas3" "nas4" ];
              }
            ];
          };
        };

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
          data = {
            type = "zfs_fs";
            options = {
              # NOTE: ZFS native mountpoints are specified inside "options"!
              mountpoint = "/mnt/data";
              canmount = "on";
            };
          };
        };
      };
    };
  };

}
