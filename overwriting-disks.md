# On overwriting disks

_Tested on OpenBSD 7.0-current_

**NOTE**: data loss may occur if you run commands in this article
without care. Ensure you target the correct disk before executing
anything.

## Table of contents

<!-- mtoc-start -->

- [The usual method](#the-usual-method)
- [Overwriting disks with a progress bar](#overwriting-disks-with-a-progress-bar)
- [Writing image files to disk with a progress bar](#writing-image-files-to-disk-with-a-progress-bar)
- [Why use dd at all then?](#why-use-dd-at-all-then)
- [Conclusion](#conclusion)

<!-- mtoc-end -->

## The usual method

It's common (and good) advice to first overwrite a disk with random data
if you plan to create an encrypted volume. The typical suggestion
involves using [`dd(1)`](https://man.openbsd.org/dd) in some fashion
like this:

    # dd if=/dev/urandom of=/dev/rsd0c bs=1m

`dd` handles this task just fine. Certain versions of `dd` support
`status=progress`. This isn't the case for OpenBSD's `dd`, but sending
`SIGINFO` will display the current status.

That said, nothing particularly distinguishes how `dd` handles
overwriting disks. As far as I can tell, `dd` leverages the power of
input and output streams in a *nix environment. Something that a tool as
simple as [`cat(1)`](https://man.openbsd.org/cat) can also do.

    # cat /dev/urandom > /dev/rsd0c

Don't mistake that as an endorsement of `cat` for this job. Better tools
exist.

## Overwriting disks with a progress bar

When overwriting disks with little storage capacity, the lack of
progress bar isn't pressing because the operation doesn't take long. For
larger disks, an estimated time of arrival (ETA) proves invaluable. I
like [`pv`](http://ivarch.com/programs/pv.shtml) for this task.

Install `pv` as a package.

    # pkg_add pv

Here, I'm plugging in a flash drive for testing purposes and running
[`dmesg(8)`](https://man.openbsd.org/dmesg) for the device name.

    $ dmesg
    [...]
    sd5 at scsibus6 targ 1 lun 0: <, USB DISK 3.0, PMAP> removable serial.655716319B52EBB03391
    sd5: 15120MB, 512 bytes/sector, 30965760 sectors

Incidentally, this already gives us the info we need to move forward
(number of sectors and number of bytes per sector). But, let's check
disk details with [`disklabel(8)`](https://man.openbsd.org/disklabel)
anyway for more information.

    # disklabel sd5
    # /dev/rsd5c:
    type: SCSI
    disk: VOID_LIVE
    label:
    duid: 0000000000000000
    flags:
    bytes/sector: 512
    sectors/track: 63
    tracks/cylinder: 255
    sectors/cylinder: 16065
    cylinders: 1927
    total sectors: 30965760
    boundstart: 0
    boundend: 30965760
    drivedata: 0

    16 partitions:
    #                size           offset  fstype [fsize bsize   cpg]
      a:         30965760                0 ISO9660
      c:         30965760                0 ISO9660

One last step before overwriting: determine how many bytes total are on
this disk by multiplying the bytes/sector value by total sectors.

    $ echo $((512 * 30965760))
    15854469120

Now we can overwrite the disk. We need `-s` for the total amount of data
to transfer, and `-S` to stop transferring once that amount has been
transferred. Without these, `pv` will display the rate of data transfer,
but not an ETA since it doesn't know how much data it will process. This
makes sense because `/dev/urandom` will never send an "end of file," so
we must tell `pv` when to stop.

    # pv -s 15854469120 -S /dev/urandom > /dev/rsd5c
    47.5MiB 0:00:02 [23.4MiB/s] [>                                                                                                                                              ]  0% ETA 0:10:34

## Writing image files to disk with a progress bar

Let's say for the sake of demonstration that I made a terrible mistake
and I really needed that live disk. No problem, we can write the data
back. I've already downloaded and cryptographically verified the image
file I'm using here. The usage is simpler here, since `pv` will detect
the size of the image file and will receive an "end of file."

    # pv void-live-x86_64-20210930.iso > /dev/rsd5c
    26.5MiB 0:00:01 [26.4MiB/s] [====>                                                                                                                                          ]  4% ETA 0:00:19

## Why use dd at all then?

`dd` offers a level of control beyond these other tools, and proves
helpful in other contexts besides writing arbitrary data to disk.
`seek=` and `skip=` are two options that come to mind for carving out
data, along with `count=` for terminating the process at a specific
point.

`dd` also eliminates the need to find the total number of bytes, since
it knows when to stop writing. This happens mainly because `dd` doesn't
redirect STDOUT with the shell to perform writing, but rather uses the
`of=` feature built into `dd`. `dd` can learn things about the nature of
the output file that `pv` won't know due to design/implementation
differences.

As an aside, it's straightforward to pipe `pv` into `dd` or vice versa,
but I haven't encountered a situation where that was necessary.

## Conclusion

I realize none of this is exactly groundbreaking---this demonstrates
pretty basic stuff, and only shows one use case for `pv`. Wacky things
are possible, like creating tarballs with a progress bar, for instance.

Nothing is wrong with keeping it traditional and using `dd`. I found
`pv` useful when writing random data to large disks so I could have some
idea of when the process would end.
