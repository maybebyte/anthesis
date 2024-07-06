# Encrypted headless Raspberry Pi running Gentoo

Published: July 6th, 2024

It took me about a week to get Gentoo running on a Raspberry Pi 4B with
full disk encryption, but I'm happy with the result and I learned a
couple of things. I wanted to share my findings so no one else has to
spend that much time trying to figure this out. :)

Note that this is a rough outline, not a step-by-step guide on how to
install Gentoo.

## What my setup involves

Here are the things that my setup involves:

- Raspberry Pi 4 Model B, Revision 1.2
- USB to UART serial cable
- Argon One M.2 case
- NVMe SSD
- microSD card

I could have also used a monitor and keyboard to set this up instead of
a serial connection. I think this would have been significantly easier
overall; however, since I'll be using the Raspberry Pi headlessly, I
wanted to know how to set it up without a keyboard and monitor.

## Covering the microSD card installation

I mainly followed [Gentoo's official Raspberry Pi Install
Guide](https://wiki.gentoo.org/wiki/Raspberry_Pi_Install_Guide) and
[Raspberry Pi4 64 Bit
Install](https://wiki.gentoo.org/wiki/Raspberry_Pi4_64_Bit_Install) to
get an initial Gentoo installation on a microSD card. However, I'd like
to talk about some pain points I faced during this process.

The hardest parts about installation for me were getting the wireless
networking and serial console to function. I'll cover each separately.

### Wireless networking

Functional wireless networking required getting a couple of things
right:

1. Downloading the firmware, placing it in the appropriate locations,
   and creating a couple of symbolic links. [This is covered in the
   Gentoo
   wiki](https://wiki.gentoo.org/wiki/Raspberry_Pi_Install_Guide#Installing_the_Raspberry_Pi_Foundation_files).
   I found referencing the Raspberry Pi OS directory listing for
   `/usr/lib/firmware/brcm/` helped me to see what the symbolic link
   naming scheme was.

   Here's what a working `/usr/lib/firmware/brcm/` looks like for me
   (though note that I haven't tested bluetooth):

   ```
   $ ls -lh /usr/lib/firmware/brcm/
   total 704K
   -rw-r--r-- 1 root root  63K Jun 24 12:07 BCM4345C0.hcd
   lrwxrwxrwx 1 root root   13 Jun 24 12:07 BCM4345C0.raspberrypi,4-model-b.hcd -> BCM4345C0.hcd
   -rw-r--r-- 1 root root 629K Jun 24 12:04 brcmfmac43455-sdio.bin
   -rw-r--r-- 1 root root 2.7K Jun 24 12:05 brcmfmac43455-sdio.clm_blob
   lrwxrwxrwx 1 root root   22 Jun 24 12:06 brcmfmac43455-sdio.raspberrypi,4-model-b.bin -> brcmfmac43455-sdio.bin
   lrwxrwxrwx 1 root root   27 Jun 24 12:06 brcmfmac43455-sdio.raspberrypi,4-model-b.clm_blob -> brcmfmac43455-sdio.clm_blob
   lrwxrwxrwx 1 root root   22 Jun 24 12:06 brcmfmac43455-sdio.raspberrypi,4-model-b.txt -> brcmfmac43455-sdio.txt
   -rw-r--r-- 1 root root 2.1K Jun 24 12:05 brcmfmac43455-sdio.txt
   ```

1. Installing software for networking, such as `net-misc/dhcpcd` and
   `net-misc/wpa_supplicant`, and configuring the software as needed.
   These things are documented in the [Gentoo
   handbook](https://wiki.gentoo.org/wiki/Handbook:Main_Page).

Despite the second step appearing straightforward, I ran into an issue
fairly quickly with this: how do I install networking tools, when I need
those same tools to configure my networking?

For many people, the easiest solution would be to plug in an Ethernet
cable and install things that way. I also read that it's possible to
download the distfiles and copy them over since in theory, `emerge`
won't need to download anything.

I already knew that I probably wouldn't be able to use Ethernet for
reasons, so I tried the distfiles method and received this error:

```
root@nasberry /etc/portage # emerge --ask net-misc/dhcpcd net-wireless/wpa_supplicant

!!! /etc/portage/make.profile is not a symlink and will probably prevent most merges.
!!! It should point into a profile within /var/db/repos/gentoo/profiles/
!!! (You can safely ignore this message when syncing. It's harmless.)


!!! Your current profile is invalid. If you have just changed your profile
!!! configuration, you should revert back to the previous configuration.
!!! Allowed actions are limited to --help, --info, --search, --sync, and
!!! --version.
```

After looking into it more, I realized that `/var/db/repos/gentoo`
didn't exist... I'd probably need to run `emerge-webrsync` to get it,
which requires networking.

What worked for me was to plug the microSD card into a USB adapter,
mount the root filesystem on my laptop, create a [QEMU
chroot](https://wiki.gentoo.org/wiki/Embedded_Handbook/General/Compiling_with_QEMU_user_chroot),
and then compile the software I needed inside the chroot using my
laptop's networking.

### Serial console

To get the serial console working, I did these things:

1. I made sure that `enable_uart=1` was present in `/boot/config.txt`. I
   found this in [the Raspberry Pi documentation for
   `config.txt`](https://www.raspberrypi.com/documentation/computers/config_txt.html)

1. I added `console=tty console=serial0,115200` to `/boot/cmdline.txt`.
   [`cmdline.txt` is documented
   here](https://www.raspberrypi.com/documentation/computers/configuration.html#kernel-command-line-cmdline-txt).

   Note that the order is quite important because whichever
   `console=` entry is last is the one that `/dev/console` is sent to. I
   found this out because mine were in the wrong order and the LUKS
   decryption prompt, as well as OpenRC output, were never being sent to
   my serial console.

   More information is available at the [kernel.org documentation for
   the serial
   console](https://www.kernel.org/doc/html/latest/admin-guide/serial-console.html).

1. For [early console
   support](https://www.raspberrypi.com/documentation/computers/configuration.html#enabling-early-console-for-linux),
   I added `earlycon=uart8250,mmio32,0xfe215040` to `/boot/cmdline.txt`.

1. To get a tty, I uncommented the line in `/etc/inittab` that points to
   the `/dev/ttyS0` device.

    ```
    # SERIAL CONSOLES
    s0:12345:respawn:/sbin/agetty -L 115200 ttyS0 vt100
    #s1:12345:respawn:/sbin/agetty -L 115200 ttyS1 vt100
    ```

## Summarizing the rest

At this point, a fully functioning Gentoo installation with wireless
networking and serial console access was present on the microSD card.
The next challenge was getting the root filesystem transferred and
working on an encrypted SSD.

The idea is that the Raspberry Pi 4B will read firmware files and
everything else needed to boot from the unencrypted EFI partition
present on the microSD card. `/boot/config.txt` and `/boot/cmdline.txt`
contain configuration entries and parameters relevant to the boot
process.

### Preparing the disk

I [securely wiped the
disk](https://wiki.archlinux.org/title/Securely_wipe_disk) by
overwriting the SSD with random data to hinder cryptanalysis and
performed a [memory cell
clearing](https://wiki.archlinux.org/title/SSD_Memory_Cell_Clearing)
(also known as "secure erase").

After that, I created a [LUKS volume with LVM inside of
it](https://wiki.archlinux.org/title/Full_disk_encryption#LVM_on_LUKS)
on the SSD. Then I [made
filesystems](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Disks)
on there as well.

### Ensuring kernel support

I made sure that support for relevant tech was built into the kernel. In
my case, this included [LVM](https://wiki.gentoo.org/wiki/LVM),
[dm-crypt](https://wiki.gentoo.org/wiki/Dm-crypt), and
[XFS](https://wiki.gentoo.org/wiki/Xfs), as these are all needed during
the boot process. Note that at the time of writing, I was only able to
boot the Raspberry Pi with `sys-kernel/raspberrypi-sources`, and not
`sys-kernel/gentoo-sources`.

### Compiling the kernel and installing it

I followed instructions presented in the [Linux kernel section of the
Raspberry Pi
docs](https://www.raspberrypi.com/documentation/computers/linux_kernel.html),
adjusting where necessary:

Create a backup of the previous kernel image if present.

```
# cp /boot/kernel8.img /boot/kernel8.img.bak
```

Change directory to kernel sources.

```
# cd /usr/src/linux
```

Build the kernel. The Raspberry Pi docs recommend setting make jobs to
1.5x the number of processors.

```
# make -j6 Image.gz modules dtbs
```

Install the kernel modules. Do this before generating the initramfs,
since the initramfs uses the modules created from this step.

```
# make -j6 modules_install
```

Run `make install` to generate the initramfs since it'll be needed to
decrypt and mount the root filesystem. `-j6` doesn't appear to provide
any benefit here.

```
# make install
```

Copy necessary files to the correct locations.

```
# cp arch/arm64/boot/Image.gz /boot/kernel8.img
# cp arch/arm64/boot/dts/broadcom/*.dtb /boot/
# cp arch/arm64/boot/dts/overlays/*.dtb* /boot/overlays/
# cp arch/arm64/boot/dts/overlays/README /boot/overlays/
```

### Editing configuration files

`/etc/fstab` needs to be adjusted to include the NVMe disk instead of the
SD card.

```
#/dev/mmcblk0p3	/	ext4	defaults	0	0
/dev/gentoolvm/root	/	xfs	defaults	0	1
```

`/boot/config.txt` needs to be adjusted. `kernel8.img` will be
automatically selected as the default kernel, but we need to add the
initramfs in.

```
initramfs initramfs-6.1.21_p20230405-raspberrypi-v8.img followkernel
```

`/boot/cmdline.txt` needs to be changed so it provides information on
where the root filesystem is located (`root=UUID=...`), what LUKS volume
to decrypt (`rd.luks.uuid=...`), and what LVM volume group to activate
(`rd.lvm.vg=lvmgroupname`). UUIDs can be found with `blkid`.

```
root=UUID=... rd.luks.uuid=... rd.lvm.vg=gentoolvm
```

### Copying the filesystem contents over

I made a full system backup of the Raspberry Pi’s microSD card with bsdtar.

```
# bsdtar \
	--acls \
	--xattrs \
	--zstd \
	--exclude='/dev/*' \
	--exclude='/proc/*' \
	--exclude='/sys/*' \
	--exclude='/tmp/*' \
	--exclude='/run/*' \
	--exclude='/mnt/*' \
	--exclude='/media/*' \
	--exclude='/lost+found/' \
	-cvaf /home/user/backup.tar.zst \
	/
```

Then I unpacked it onto the SSD. The LUKS partition was decrypted and
the filesystems were mounted at `/mnt`.

```
# cd /mnt
# bsdtar --acls --xattrs -xvpf /home/user/backup.tar.zst
```

After rebooting, I was presented with the decryption prompt and was able
to boot the rest of the system.

## Conclusion and thoughts

This setup won't prevent a determined adversary from removing the SD
card and tampering with anything on the boot partition (the kernel; the
initramfs; the firmware), nor does it prevent hardware level attacks. An
attacker could theoretically leverage these to obtain the encryption
password entered on boot. But the encryption does protect the data
itself when the Raspberry Pi is powered off. Besides, a targeted and
sophisticated attack like that isn't currently in my threat model. This
is more about raising the level of difficulty to recover the data.

If those types of attacks ever did become part of my threat model,
perhaps I'd look into Secure Boot on the Raspberry Pi.
