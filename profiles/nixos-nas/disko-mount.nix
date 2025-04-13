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
          ashift = "12";                    # set 4KB block size
        };
        # Filesystem level options (what/when youre storing)
        rootFsOptions = {
          acltype = "posixacl";             # fine-grained permission control (getfacl, setfacl)
          atime = "off";                    # disable access time updates, for performance
          compression = "lz4";              # enable compression
          mountpoint = "none";
          recordsize = "1M";                # optimize size for large file workloads
          secondarycache = "none";          # disable L2ARC
          xattr = "sa";                     # set metadata directly in inodes, over separate hidden files
          "com.sun:auto-snapshot" = "true"; # used by services.zfs.autoSnapshot options
        };

        # NOTE: ZFS native mountpoints are specified inside "options"!
        datasets = {

          # --------------------------------
          # Stuff that cant be lost

          config = {
            type = "zfs_fs";
            options = {
              mountpoint = "/mnt/data/config";
              canmount = "on";
              recordsize = "16K";
            };
          };
          code = {
            type = "zfs_fs";
            options = {
              mountpoint = "/mnt/data/code";
              canmount = "on";
              recordsize = "16K";
            };
          };
          documents = {
            type = "zfs_fs";
            options = {
              mountpoint = "/mnt/data/documents";
              canmount = "on";
              recordsize = "128K";
            };
          };
          pictures = {
            type = "zfs_fs";
            options = {
              mountpoint = "/mnt/data/pictures";
              canmount = "on";
            };
          };

          # --------------------------------
          # Stuff that can be lost

          cache = {
            type = "zfs_fs";
            options = {
              mountpoint = "/mnt/data/cache";
              canmount = "on";
              recordsize = "128K";
            };
          };
          downloads = {
            type = "zfs_fs";
            options = {
              mountpoint = "/mnt/data/downloads";
              canmount = "on";
            };
          };
          games = {
            type = "zfs_fs";
            options = {
              mountpoint = "/mnt/data/games";
              canmount = "on";
            };
          };
          music = {
            type = "zfs_fs";
            options = {
              mountpoint = "/mnt/data/music";
              canmount = "on";
            };
          };
          videos = {
            type = "zfs_fs";
            options = {
              mountpoint = "/mnt/data/videos";
              canmount = "on";
            };
          };

        };
      };
    };
  };

}
