{
  disko.devices = {
    disk = {
      # OS drive
      os = {
        device =
          "/dev/disk/by-id/ata-Samsung_SSD_840_PRO_Series_S1ANNEAD612962T";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            # boot partition
            ESP = {
              type = "EF00";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            # root partition
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
