# Lunar's nixos configuration

This configuration can be applied to any running nixos configuration without copying it to
/etc/nixos at all. Use `boot.sh` to do `nixos-rebuild boot` which will build new bootable system
and register it in your bootloader without breaking previous or current ones, but note:
Before using this configuration if you have encryptied nixos system
you may need to copy line from /etc/nixos/configuration.nix to
/etc/nixos/hardware-configuration.nix, my one was
`  boot.initrd.luks.devices."luks-b68c32f9-a612-4ead-b2f5-cf16ca165664".device = "/dev/disk/by-uuid/b68c32f9-a612-4ead-b2f5-cf16ca165664";`
If there's no such line, it means you don't need to copy it.
Don't worry anyway, if you won't copy this line or if you do something wrong you'll still be able to change boot entry to older configuration.
Nothing will break.

I recommend using `boot.sh` script to build bootable image and then reboot your system to that one.
`uboot.sh` does same as boot, but it updates flake.lock before building new system.
