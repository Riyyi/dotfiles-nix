let
  mdDisk = { device, idx }: {
    type = "disk";
    device = "/dev/disk/by-id/${device}";
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
            mountpoint = if idx == 0 then "/boot" else "/boot2";
            mountOptions = [ "umask=0077" ];
          };
        };
        # root partition
        mdadm = {
          size = "100%";
          content = {
            type = "mdraid";
            name = "raid1";
          };
        };
      };
    };
  };
in
{

  disko.devices = {
    disk = {
      disk1 = mdDisk { device = "wwn-0x500253855039074a"; idx = 0; };
      disk2 = mdDisk { device = "wwn-0x500253855039074b"; idx = 1; };
    };
    mdadm = {
      raid1 = {
        type = "mdadm";
        level = 1;
        content = {
          type = "gpt";
          partitions.primary = {
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

}
