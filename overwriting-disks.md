# On overwriting disks

*Tested on OpenBSD 7.0-current*

Note: Data loss may be caused by blindly running commands in this
article. Ensure the right disk is being targeted before executing
anything.

## The usual method

It's common (and good) advice to first overwrite a disk with random data
if it's to be an encrypted volume. The typical suggestion is to use
[`dd(1)`](https://man.openbsd.org/dd) in some fashion similar to this:

```
# dd if=/dev/urandom of=/dev/rsd0c bs=1m
```

`dd` handles this task just fine. If you use GNU `dd`, there's
`status=progress` (for those on *BSD, sending `SIGINFO` displays the
current status and there is no `status=progress`).

That said, there's nothing particularly special about how `dd` handles
overwriting disks to my knowledge. As far as I can tell, `dd` is
leveraging the power of input and output streams in a *nix environment.
Something that can be done by a tool as simple as
[`cat(1)`](https://man.openbsd.org/cat).

```
# cat /dev/urandom > /dev/rsd0c
```

Don't mistake that as an endorsement of `cat` for this job. There are
better tools.

## Overwriting disks with a progress bar

When overwriting disks with little storage capacity, the lack of
progress bar isn't a pressing issue because the operation doesn't take a
long time. For larger disks, an ETA proves invaluable. I like
[`pv`](http://ivarch.com/programs/pv.shtml) for this task.

Install `pv` as a package.

```
# pkg_add pv
```

Here, I'm plugging in a flash drive for testing purposes and running
[`dmesg(8)`](https://man.openbsd.org/dmesg) for the device name.

```
$ dmesg
[...]
sd5 at scsibus6 targ 1 lun 0: <, USB DISK 3.0, PMAP> removable serial.655716319B52EBB03391
sd5: 15120MB, 512 bytes/sector, 30965760 sectors
```

Incidentally, this already gives us the info we need to progress forward
(number of sectors and number of bytes per sector). But, let's check disk
details with [`disklabel(8)`](https://man.openbsd.org/disklabel) anyway
for some more information.

```
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
```

One last step before overwriting: determine how many bytes total are on
this disk, by multiplying the bytes/sector value by total sectors.

```
$ echo $((512 * 30965760))
15854469120
```

Now we can overwrite the disk. We need `-s` for the total amount of data
to be transferred, and `-S` to stop transferring once that amount has
been transferred. Without these, `pv` will display the rate of data
transfer, but not an ETA since it doesn't know how much data it's going
to process overall. This makes sense because `/dev/urandom` will never send an "end
of file," so we have to tell `pv` when to stop.

```
# pv -s 15854469120 -S /dev/urandom > /dev/rsd5c
47.5MiB 0:00:02 [23.4MiB/s] [>                                                                                                                                              ]  0% ETA 0:10:34
```

## Writing image files to disk with a progress bar

Let's say for the sake of demonstration that I've made a terrible
mistake and I really needed that live disk. No problem, we can write the
data back. The image file I'm using here has already been downloaded
and cryptographically verified. The usage is simpler here, since `pv`
will detect the size of the image file and will receive an "end of
file."

```
# pv void-live-x86_64-20210930.iso > /dev/rsd5c
26.5MiB 0:00:01 [26.4MiB/s] [====>                                                                                                                                          ]  4% ETA 0:00:19
```

## Why use dd at all then?

`dd` offers a level of control beyond these other tools, and is helpful
for a variety of other contexts besides writing arbitrary data to disk.
`seek=` and `skip=` are two options that come to mind for carving out
data, as well as `count=` for terminating the process at a specific
point.

`dd` alleviates the need to find the total number of bytes, too, since
it knows when to stop writing (mainly because `dd` isn't redirecting
STDOUT with the shell to perform writing, but rather using the `of=`
functionality baked into `dd`, so `dd` can handle output in ways `pv`
doesn't due to design/implementation).

As an aside, it's easy enough to pipe `pv` into `dd`, but I haven't run
into a situation where that was a necessary step.

## Conclusion

I realize none of this is exactly groundbreaking in that this is pretty
rudimentary stuff, and only demonstrates one use case for `pv` (wacky
things are possible--creating tarballs with a progress bar, for
instance). There's also nothing wrong with keeping it traditional and
using `dd`. I found `pv` useful when writing random data to large disks
so I could have some idea of when the process would end without any
calculation/estimation necessary on my part.
