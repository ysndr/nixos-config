# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:
let

  st-link-udev-rules = pkgs.runCommand "st-link-udev-rules" {} ''
   install -Dm644 -t $out/etc/udev/rules.d ${./etc/udev/rules.d}/* '';

in {
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" 
"usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.extraModprobeConfig =
  ''
    options snd-hda-intel power_save=1
  '';
  boot.kernelParams = ["acpi_backlight=video" "acpi_osi=Linux" ];
  virtualisation.virtualbox.guest.enable=true;
  # Uses systemd uefi bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # /tmp on tmpfs
  boot.tmpOnTmpfs = true;

  # Video
  services.xserver.videoDrivers = [ "intel" ];

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

/**
 * Enable to use steam proton based games
 * dont forget to diable all bumblebee related stuff
  service.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
  modesetting.enable = true;

          optimus_prime = {
            enable = true;
            # values are from lspci
            # try lspci | grep -P 'VGA|3D'
            intelBusId = "PCI:00:02:0";
            nvidiaBusId = "PCI:01:00:0";
          };
  }; 
*/

#  hardware.bumblebee.enable = true;
#  hardware.bumblebee.driver = "nvidia";
#  hardware.bumblebee.group = "video";

# hardware.bumblebee.pmMethod = "bbswitch";
# hardware.bumblebee.connectDisplay = true;

#  hardware.opengl.extraPackages = [ pkgs.linuxPackages.nvidia_x11.out ];
#  hardware.opengl.extraPackages32 = [ pkgs.linuxPackages.nvidia_x11.lib32 ];

  # Sound
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull;
  };

  # To just use intel integrated graphics with Intel's open source driver
  # hardware.nvidiaOptimus.disable = true;

  # microcode
  hardware.cpu.intel.updateMicrocode = true;
  # fwupd
  services.fwupd.enable = false;


  # activate bluetooth
  hardware.bluetooth.enable = true;

  # activate logitech device support
  hardware.logitech = {
    enable = true;
    enableGraphical = true; # for solaar to be included
  };

  services.udev.packages = [ st-link-udev-rules ];

  # services.udev.extraHwdb = ''
  # ''
  # + builtins.readFile  (./udev/hwdb.d/99-logitech-mx-master-2s-click-angle.hwdb);


  # File system mounts
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/3f7a1eb9-aba1-4dbf-b87c-5a99c7f38b3d";
      fsType = "btrfs";
      options = [ "subvol=root/nixos-09-2017" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/c1579a69-8ddb-45ed-8879-e94ea6d5c062";
      fsType = "xfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/AAFA-A81A";
      fsType = "vfat";
    };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 4;

 services.tlp.enable = true;

 powerManagement = rec {
    enable = true;
#    cpuFreqGovernor = "powersave"; # set by tlp
    powerUpCommands =
    ''
      ${pkgs.hdparm}/sbin/hdparm -B1yYS6 /dev/sda
    '';
    resumeCommands = powerUpCommands;
  };
}
