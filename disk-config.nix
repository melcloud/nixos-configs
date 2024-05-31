{
  disks ? [ "/dev/nvme0n1" ],
  lib,
  brtfsMountOptions ? [ "defaults" "compress=zstd" "noatime" "discard=async" "commit=120" ],
  swapSize,
  ...
}: {
  disko.devices = {
    disk = {
      nvme0n1 = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                ];
              };
            };
            LUKS = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                settings = {
                  allowDiscards = true;
                };
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
                  extraArgs = [ "-f" "-L NIXOS" ];
                  postMountHook = ''
                  if [ -d /mnt/var/lib/libvirt ]; then
                  chattr +C /mnt/var/lib/libvirt
                  fi
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
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = brtfsMountOptions;
                    };
                    "@swap" = {
                      mountpoint = "/.swapvol";
                      swap.swapfile.size = swapSize;
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
            };
          };
        };
      };
    };
    nodev = {
      "/tmp" = {
        fsType = "tmpfs";
        mountOptions = [
          "size=2g"
        ];
      };
      "/run" = {
        fsType = "tmpfs";
        mountOptions = [
          "size=1g"
        ];
      };
    };
  };
}
