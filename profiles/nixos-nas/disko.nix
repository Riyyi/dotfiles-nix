{

  disko.devices = {
    disk = {
      # OS drive
      os = {
        device = "/dev/disk/by-id/wwn-0x500253855039074b";
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
