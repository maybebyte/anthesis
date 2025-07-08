# Encrypted headless Raspberry Pi running Gentoo

Published: July 6th, 2024

Last updated: July 3rd, 2025

Setting up Gentoo on a Raspberry Pi 4B with full disk encryption took me
about a week, but I'm happy with the result and learned several things
along the way. I want to share my findings so others don't have to spend
as much time figuring this out.

Note that this provides a rough outline, not a step-by-step guide for
installing Gentoo.

## Table of contents

<!-- mtoc-start -->

- [What my setup involves](#what-my-setup-involves)
- [Covering the microSD card installation](#covering-the-microsd-card-installation)
  - [Wireless networking](#wireless-networking)
  - [Serial console](#serial-console)
- [Summarizing the rest](#summarizing-the-rest)
  - [Preparing the disk](#preparing-the-disk)
  - [Ensuring kernel support](#ensuring-kernel-support)
  - [Compiling the Raspberry Pi foundation kernel and installing it](#compiling-the-raspberry-pi-foundation-kernel-and-installing-it)
  - [Editing configuration files](#editing-configuration-files)
  - [Copying the filesystem contents over](#copying-the-filesystem-contents-over)
  - [Switching to gentoo-sources](#switching-to-gentoo-sources)
- [Conclusion and thoughts](#conclusion-and-thoughts)

<!-- mtoc-end -->

## What my setup involves

Here are the components my setup uses:

- Raspberry Pi 4 Model B, Revision 1.2
- Universal Serial Bus (USB) to Universal Asynchronous
  Receiver/Transmitter (UART) serial cable
- Argon One M.2 case
- Non-Volatile Memory Express (NVMe) Solid State Drive (SSD)
- Micro Secure Digital (microSD) card

I could have used a monitor and keyboard instead of a serial connection.
This would have been easier overall. Since I planned to use the
Raspberry Pi headlessly, I wanted to learn how to set it up without a
keyboard and monitor.

## Covering the microSD card installation

I mainly followed [Gentoo's official Raspberry Pi Install
Guide](https://wiki.gentoo.org/wiki/Raspberry_Pi_Install_Guide) and
[Raspberry Pi4 64 Bit
Install](https://wiki.gentoo.org/wiki/Raspberry_Pi4_64_Bit_Install) to
get an initial Gentoo installation on a microSD card. I want to discuss
some difficulties I encountered during this process.

The most challenging parts of the installation were getting wireless
networking and the serial console working. I'll cover each separately.

### Wireless networking

Getting wireless networking functional required handling a couple of
tasks correctly:

1. Download the firmware, place it in the appropriate locations, and
   create symbolic links. [The Gentoo wiki covers this
   process](https://wiki.gentoo.org/wiki/Raspberry_Pi_Install_Guide#Installing_the_Raspberry_Pi_Foundation_files).
   I found that referencing the Raspberry Pi Operating System (OS)
   directory listing for `/usr/lib/firmware/brcm/` helped me understand the
   symbolic link naming scheme.

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

2. Install networking software like `net-misc/dhcpcd` and
   `net-misc/wpa_supplicant`, then configure the software as needed. The
   [Gentoo handbook](https://wiki.gentoo.org/wiki/Handbook:Main_Page)
   documents these steps.

Despite the second step appearing straightforward, I encountered an
issue. How do I install networking tools when I need those same tools to
configure networking?

For many people, the easiest solution would be plugging in an Ethernet
cable and installing packages that way. I also read that downloading the
distfiles and copying them over manually works, since in theory,
`emerge` won't need to download anything.

I already knew that I wouldn't have Ethernet access, so I tried the
distfiles method and received this error:

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

After investigating further, I realized that `/var/db/repos/gentoo`
didn't exist. I would need to run `emerge-webrsync` to get it, which
requires networking.

What worked for me was to plug the microSD card into a USB adapter,
mount the root filesystem on my laptop, create a [Quick Emulator (QEMU)
chroot](https://wiki.gentoo.org/wiki/Embedded_Handbook/General/Compiling_with_QEMU_user_chroot),
and then compile the software I needed inside the chroot using my
laptop's networking.

### Serial console

To get the serial console working, I completed these steps:

1. I ensured that `enable_uart=1` appeared in `/boot/config.txt`. I
   found this in [the Raspberry Pi documentation for
   `config.txt`](https://www.raspberrypi.com/documentation/computers/config_txt.html).

2. I added `console=tty console=serial0,115200` to `/boot/cmdline.txt`.
   [`cmdline.txt` documentation is available
   here](https://www.raspberrypi.com/documentation/computers/configuration.html#kernel-command-line-cmdline-txt).

   Note that the order matters because whichever `console=` entry
   appears last becomes the destination for `/dev/console`. I discovered
   this because mine were in the wrong order and the Linux Unified Key
   Setup (LUKS) decryption prompt, as well as OpenRC output, never
   appeared on my serial console.

   More information is available at the [kernel.org documentation for
   the serial
   console](https://www.kernel.org/doc/html/latest/admin-guide/serial-console.html).

3. For [early console
   support](https://www.raspberrypi.com/documentation/computers/configuration.html#enabling-early-console-for-linux),
   I added `earlycon=uart8250,mmio32,0xfe215040` to `/boot/cmdline.txt`.

4. To get a tty, I uncommented the line in `/etc/inittab` that points to
   the `/dev/ttyS0` device.

   ```
   # SERIAL CONSOLES
   s0:12345:respawn:/sbin/agetty -L 115200 ttyS0 vt100
   #s1:12345:respawn:/sbin/agetty -L 115200 ttyS1 vt100
   ```

## Summarizing the rest

At this point, I had a fully functioning Gentoo installation with
wireless networking and serial console access on the microSD card. The
next challenge was transferring the root filesystem to an encrypted SSD
and getting it working.

The approach I used involves having the Raspberry Pi 4B read firmware
files and everything else needed to boot from the unencrypted Extensible
Firmware Interface (EFI) partition on the microSD card.
`/boot/config.txt` and `/boot/cmdline.txt` contain configuration entries
and parameters relevant to the boot process.

### Preparing the disk

I [securely wiped the
disk](https://wiki.archlinux.org/title/Securely_wipe_disk) by
overwriting the SSD with random data to hinder cryptanalysis and
performed a [memory cell
clearing](https://wiki.archlinux.org/title/SSD_Memory_Cell_Clearing)
(also known as "secure erase").

After that, I created a [LUKS volume with Logical Volume Manager (LVM)
inside
it](https://wiki.archlinux.org/title/Full_disk_encryption#LVM_on_LUKS)
on the SSD. Then I [created
filesystems](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Disks)
on the logical volumes.

### Ensuring kernel support

I ensured that the kernel included support for relevant technologies. In
my case, this included [LVM](https://wiki.gentoo.org/wiki/LVM),
[dm-crypt](https://wiki.gentoo.org/wiki/Dm-crypt), and
[XFS](https://wiki.gentoo.org/wiki/Xfs), as the system needs these
during the boot process.

You can choose between `sys-kernel/raspberrypi-sources` and
`sys-kernel/gentoo-sources`. I can confirm that both work, although I
started with `sys-kernel/raspberrypi-sources` first.
`sys-kernel/gentoo-sources` lacks some features like device tree overlay
support, but it works for my use case.

Other kernels like the distribution kernel could work, but I haven't
tested them.

### Compiling the Raspberry Pi foundation kernel and installing it

I followed instructions from the [Linux kernel section of the Raspberry
Pi
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

Install the kernel modules. Complete this step before generating the
initramfs, since the initramfs uses the modules created from this step.

```
# make -j6 modules_install
```

Run `make install` to generate the initramfs since you'll need it to
decrypt and mount the root filesystem. `-j6` doesn't seem to provide any
benefit here.

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

Update `/etc/fstab` to include the NVMe disk instead of the SD card.

```
#/dev/mmcblk0p3	/	ext4	defaults	0	0
/dev/gentoolvm/root	/	xfs	defaults	0	1
```

Update `/boot/config.txt`. The system will automatically select
`kernel8.img` as the default kernel, but you need to add the initramfs.

```
initramfs initramfs-6.6.31_p20240529-raspberrypi-v8.img followkernel
```

Update `/boot/cmdline.txt` so it provides information about the root
filesystem location (`root=UUID=...`), which LUKS volume to decrypt
(`rd.luks.uuid=...`), and which LVM volume group to activate
(`rd.lvm.vg=gentoolvm`). You can find UUIDs with `blkid`.

```
root=UUID=... rd.luks.uuid=... rd.lvm.vg=gentoolvm
```

### Copying the filesystem contents over

I created a full system backup of the Raspberry Pi's microSD card with
bsdtar.

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

Then I unpacked it onto the SSD. I had decrypted the LUKS partition and
mounted the filesystems at `/mnt`.

```
# cd /mnt
# bsdtar --acls --xattrs -xvpf /home/user/backup.tar.zst
```

After rebooting, the system presented the decryption prompt and I could
boot successfully.

### Switching to gentoo-sources

The Raspberry Pi foundation kernel lacks security support from Gentoo,
so I wanted to switch to `sys-kernel/gentoo-sources`. This process is
straightforward.

Change directory to the new kernel sources.

```
$ cd /usr/src/linux-6.6.30-gentoo
```

Copy the working config over.

```
# cp /usr/src/linux-6.6.31_p20240529-raspberrypi/.config .
```

Update the current kernel configuration so it works with this kernel.

```
# make oldconfig
```

Follow the previous process to build the kernel, except skip copying the
overlay files since `sys-kernel/gentoo-sources` doesn't create them.
Once complete, update `/boot/config.txt` so it points to the correct
initramfs file.

Another step I had to complete was updating `/boot/cmdline.txt` to
include `8250.nr_uarts=1`, otherwise the [serial console fails to
initialize](https://forums.raspberrypi.com/viewtopic.php?t=246215).

## Conclusion and thoughts

This setup won't prevent a determined adversary from removing the
microSD card and tampering with anything on the boot partition (the
kernel, the initramfs, or the firmware). It also doesn't prevent
hardware-level attacks. If an attacker leverages these, they can obtain
the encryption password entered on boot.

Still, the encryption protects the data when the Raspberry Pi is powered
off. This setup raises the difficulty level for data recovery, but it
doesn't account for sophisticated attacks like this.

If those types of attacks ever became part of my threat model, I would
look into Secure Boot on the Raspberry Pi.
