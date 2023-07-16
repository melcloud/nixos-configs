{ disks ? [ "/dev/nvme0n1" ], lib, brtfsMountOptions ? [ "defaults" ], ... }: {
  disko.devices = {
    disk = {
      nvme0n1 = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "table";
          format = "gpt";
          partitions = [
            {
              name = "ESP";
              start = "1MiB";
              end = "512MiB";
              fs-type = "fat32";
              bootable = true;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            }
            {
              name = "LUKS";
              start = "512MiB";
              end = "100%";
              content = {
                type = "luks";
                name = "crypted";
                extraFormatArgs = [
                  "--type luks2"
                  "--cipher aes-xts-plain64"
                  "--hash sha256"
                  "--key-size 512"
                  "--pbkdf argon2id"
                  "--iter-time 2000"
                  "--use-urandom"
                  "--verify-passphrase"
                ];
                extraOpenArgs = [
                  "--perf-no_read_workqueue"
                  "--perf-no_write_workqueue"
                  "--persistent"
                ];
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" "-l NIXOS" "-R free-space-tree" ];
                  postMountHook = ''
                    btrfs filesystem mkswapfile --size "$(( $(free -b | awk 'NR == 2 {print $2}') + 1073741824 ))" "${mountpoint}/swapfile"
                    chattr +C /var/lib/libvirt/
                  '';
                  subvolumes = {
                    "@" = {
                      mountpoint = "/";
                      mountOptions = brtfsMountOptions;
                    };
                    "@snapshots" = {
                      mountpoint = "/.snapshots";
                      mountOptions = brtfsMountOptions;
                    };
                    "@home_root" = {
                      mountpoint = "/root";
                      mountOptions = brtfsMountOptions;
                    };
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = brtfsMountOptions;
                    };
                    "@srv" = {
                      mountpoint = "/srv";
                      mountOptions = brtfsMountOptions;
                    };
                    "@opt" = {
                      mountpoint = "/opt";
                      mountOptions = brtfsMountOptions;
                    };
                    "@swap" = {
                      mountpoint = "/swap";
                      mountOptions = "defaults,noatime,commit=120";
                    };
                    "@var_log" = {
                      mountpoint = "/var/log";
                      mountOptions = brtfsMountOptions;
                    };
                    "@var_cache" = {
                      mountpoint = "/var/cache";
                      mountOptions = brtfsMountOptions;
                    };
                    "@var_tmp" = {
                      mountpoint = "/var/tmp";
                      mountOptions = brtfsMountOptions;
                    };
                    "@var_libvirt" = {
                      mountpoint = "/var/lib/libvirt";
                      mountOptions = brtfsMountOptions;
                    };
                    "@var_containers" = {
                      mountpoint = "/var/lib/containers";
                      mountOptions = brtfsMountOptions;
                    };
                  };
                };
              };
            }
          ];
        };
      };
    };
    nodev = {
      "/tmp" = {
        fsType = "tmpfs";
        mountOptions = [
          "size=4GiB"
        ];
      };
      "/run" = {
        fsType = "tmpfs";
        mountOptions = [
          "size=1GiB"
        ];
        postMountHook = ''
        mkdir -p /var/run/ /var/lock/ /run/lock/
        ln -s /run/ /var/run/
        ln -s /run/lock/ /var/lock/
        '';
      };
      "/swap/swapfile" = {
        fsType = "swap";
      };
    };
  };
}
