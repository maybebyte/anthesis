# Setting up a 4K Kodi box with sndio on FreeBSD

*Tested on FreeBSD 13.0-RELEASE*

## Overview

Everyone needs a break sometimes. In my case, I find myself watching
videos and listening to music frequently, and sometimes I'd rather play
media over speakers than headphones (they're a different experience,
with pros and cons to each).

I'm aware there are Linux distributions that provide a decent
out-of-the-box experience with Kodi. The one that comes to mind is
[LibreELEC](https://libreelec.tv/). I've used it before, and I'd say
LibreELEC would suffice for the average person.

However, I strongly prefer to have control over how everything
functions, even if it requires some initial setup. What really matters
to me is how pleasant it is to extend and maintain a given system. In my
eyes, setup is the short game and maintenance is the long game.

I also have gripes with the implementation. If I don't have the last word
in how a system works, then I'm typically disinterested because it means
I'll have a harder time fixing it if something goes wrong. Given these
factors, I set out to create my own entertainment center that met my
specific needs on a Latte Panda Delta.

## Installation

For the sake of brevity, I won't cover the process of installing FreeBSD in depth. It's
[well-documented
elsewhere](https://docs.freebsd.org/en/books/handbook/bsdinstall/), and
I'm not doing anything out of the ordinary during this
phase.

Here's the short of it:

1. [Obtain an installation image for
amd64](https://www.freebsd.org/where/).

1. Verify the image's checksum and GPG signature. Without this, there is
   no assurance that the installation image is from the source it claims
   to be and that it hasn't been tampered with.

1. Flash the image to a USB drive.

1. Boot from the USB drive and go through the installation procedure.

## After installation

This is where it starts getting more specific. I'm a really big fan of
[sndio](https://sndio.org/), so I use ports instead of packages because
Kodi isn't built with `sndio` support by default. Admittedly, this makes
the post-installation phase much more tedious.

Log in to the freshly installed FreeBSD box and follow along.

### Setting up power management

Enable and start
[`powerd(8)`](https://www.freebsd.org/cgi/man.cgi?sektion=0&manpath=FreeBSD%2013.0-RELEASE&arch=default&format=html&query=powerd)
for power management. In theory, it will lower power consumption when
the entertainment center isn't doing much.

	# sysrc powerd_enable="YES"
	# service powerd start

### Creating make.conf

To get it out of the way before compiling anything to ensure changes are
immediately effective, set up
[`make.conf(5)`](https://www.freebsd.org/cgi/man.cgi?sektion=0&manpath=FreeBSD%2013.0-RELEASE&arch=default&format=html&query=make.conf).

To keep things up to date, [my make.conf is available and managed by
git](/src/sysadm/file/examples/freebsd/poudriere/make.conf.html), but
please do not copy it blindly. It specifies everything needed to compile
against sndio, LibreSSL, and Intel Quick Sync Video.

### Checking out source code

#### Checking out the ports tree

[See the FreeBSD handbook entry on ports for more details](https://docs.freebsd.org/en/books/handbook/ports/#ports-using).

	# portsnap fetch extract

#### Installing portmaster

Install a ports management tool. For the purpose of simplicity, I'll
choose `ports-mgmt/portmaster` here. `ports-mgmt/poudriere` is also
good and what I use these days, but teaching how to use it here is out
of scope. `portmaster` gets the job done.

	# make -C /usr/ports/ports-mgmt/portmaster install clean

#### Checking out FreeBSD's source code

Install `git`, as it's needed for checking out the source tree. I
like the `git-tiny` flavor.

	# portmaster devel/git@tiny

[Check out the source tree](https://docs.freebsd.org/en/books/handbook/cutting-edge/#updating-src-obtaining-src).
This is required for building `graphics/drm-kmod`.

	# git clone https://git.freebsd.org/src.git -b releng/13.0 /usr/src

### Odds and ends before compiling Kodi

#### Installing needed tools

I like to install a couple of tools to make myself comfortable before
building Kodi. In particular, I find `sysutils/tmux` to be essential,
because one can detach from a `tmux` session and log out while
`portmaster` is building, then later log in and reattach to check on
the build.

I definitely recommend `security/doas` as a simple method of
privilege elevation.

Consider installing a text editor and a shell in addition to the
aforementioned tools, if desired. I like `editors/neovim` and
`shells/oksh`.

	# portmaster sysutils/tmux security/doas

#### Setting up doas.conf

If `security/doas` was installed, set up
[`doas.conf(5)`](https://man.openbsd.org/doas.conf). Since persistence
is currently unsupported on FreeBSD, I add `nopass` for my own sanity.

	# echo 'permit nopass :wheel' >/usr/local/etc/doas.conf

#### Entering a tmux session

This is important for the next part. This one-liner checks to see if the
current user has a `tmux` session currently open. If not, it first tries
to attach to an existing session, and creates a new session if that
fails.

	$ [ -z "${TMUX}" ] && { tmux attach || tmux; }

### Compiling Kodi

#### Using portmaster to compile ports

Alright, it's finally time to compile Kodi.

Note: if ports configuration isn't desired beyond what's already
specified in `make.conf`, prepend `BATCH=1` to the below command. I
recommend at least looking over the options available for
`multimedia/ffmpeg` and `multimedia/kodi` with `make config`.

Remember to install packages needed for [Hardware video
acceleration](https://wiki.archlinux.org/title/Hardware_video_acceleration).
In the Latte Panda Delta's case, they are
`multimedia/libva-intel-media-driver` and
`multimedia/libvdpau-va-gl`.

	# portmaster audio/sndio graphics/drm-kmod multimedia/libva-intel-media-driver \
	> multimedia/libvdpau-va-gl x11/xorg misc/unclutter-xfixes multimedia/kodi \
	> multimedia/kodi-addon-inputstream.adaptive

After giving permission to `portmaster` to build everything, detach from
the `tmux` session (`CTRL-b d` is the default binding. Alternatively,
create a second window with `CTRL-b c` and issue `tmux detach`).  Then,
kill the SSH connection and take a fifteen minute break or so.

Once that initial fifteen minute break is over, SSH in and `tmux attach`
to see if there were any errors encountered early on that need to be
addressed. It's tedious to wait several hours only to realize that
`portmaster` wasn't actually compiling anything for most of that time.
Now it's time to relax. Compiling Kodi and Xorg on a single board
computer isn't too speedy.

#### Reviewing installation messages

Review installation messages to check for needed interventions.

	$ pkg query '%M' | less

### Setting up a user environment for Kodi

#### Creating the kodi user

Create a separate user for Kodi (I named mine `kodi`, and will
refer to this separate user as such for the rest of this article). Make
sure to add `kodi` to the `video` group.

	# adduser

If `kodi` wasn't added to the `video` group during this process, no
problem. This can be remedied like so:

	# pw groupmod video -m kodi

After that, make sure to log in as `kodi`.

#### Creating .xinitrc

To initialize a graphical environment, we need to create
`/home/kodi/.xinitrc`.

The `xset` commands are here to prevent interference with Kodi's screen
blanking mechanisms. `unclutter` ensures that the cursor won't
remain visible if idle (though the cursor is usually invisible during
ordinary usage--it's merely a fallback in case it does become visible.
One common example is if a pointer device is accidentally bumped).

	$ cat <<EOF >~/.xinitrc
	> . "${HOME}/.profile"
	> xset s noblank
	> xset s off
	> xset -dpms
	> unclutter &
	>
	> exec kodi
	> EOF

#### Starting X

From a console (not SSH), start X.

	$ startx

If it works, log out of `kodi` and back in to the user with root access.

### Starting Kodi automatically

#### Setting up gettytab

It can be helpful for Kodi to start automatically on boot. Some things
are required for this to work: the first is that `kodi` needs
to be automatically logged in. To address this, append some magic to
[`gettytab(5)`](https://www.freebsd.org/cgi/man.cgi?sektion=0&manpath=FreeBSD%2013.0-RELEASE&arch=default&format=html&query=gettytab).

	# cat <<EOF >>/etc/gettytab
	> # autologin kodi
	> A|Al|Autologin console:\
	>	:ht:np:sp#115200:al=kodi
	> EOF

#### Editing ttys

Edit
[`ttys(5)`](https://www.freebsd.org/cgi/man.cgi?query=ttys&apropos=0&sektion=0&manpath=FreeBSD+13.0-RELEASE&arch=default&format=html)
to match below.

	# Virtual terminals
	#ttyv1	"/usr/libexec/getty Pc"	xterm	onifexists	secure
	ttyv1	"/usr/libexec/getty Al"	xterm	onifexists	secure

#### Ensuring X only starts in the correct TTY

As `kodi`, append this simple check to `/home/kodi/.profile`.
Essentially, it makes sure X isn't running and that it would start X
in the correct tty before doing so.

	$ cat <<EOF >>~/.profile
	> if [ -z "${DISPLAY}" ] && [ "$(tty)" = '/dev/ttyv1' ]; then
	> 	exec startx
	> fi
	> EOF

Finally, reboot.

	# reboot

### Configuring the sound system

If everything is good, it's time to configure the sound system. Set the
default device with
[`sysctl(8)`](https://www.freebsd.org/cgi/man.cgi?sektion=0&manpath=FreeBSD%2013.0-RELEASE&arch=default&format=html&query=sysctl)
if needed (inspect `/dev/sndstat` for a list of devices).

	# sysctl hw.snd.default.unit=1 # needed for HDMI in my case.

Now, decide whether bit-perfect mode will be used or not and consult
the relevant section below. Note that the ["Sync playback to
display"](https://kodi.wiki/view/Settings/Player/Videos#Sync_playback_to_display)
option in Kodi is fundamentally incompatible with bit-perfect audio, as
it resamples both video and audio to match the refresh rate of the monitor.

#### Bit-perfect

To use bit-perfect mode, two `sysctl` tweaks are needed. Here,
I use the first device, but be sure to check what device needs to be
adjusted.

	# sysctl dev.pcm.1.bitperfect=1
	# sysctl hw.snd.maxautovchans=0

#### Not bit-perfect

I recommend changing `hw.snd.feeder_rate_quality` from its default of
`1`. According to
[`sound(4)`](https://www.freebsd.org/cgi/man.cgi?sektion=0&manpath=FreeBSD%2013.0-RELEASE&arch=default&format=html&query=sound),
the default of linear interpolation doesn't provide anti-aliasing
filtering. I like to start from the highest resampling quality possible
and lower the value if needed.

	# sysctl hw.snd.feeder_rate_quality=4

Remember that regardless which mode of operation was selected, if tweaks
made with `sysctl` are to be permanent,
[`sysctl.conf(5)`](https://www.freebsd.org/cgi/man.cgi?sektion=0&manpath=FreeBSD%2013.0-RELEASE&arch=default&format=html&query=sysctl.conf)
must be modified accordingly.

[Note that `sndiod` is not needed in either case](https://forums.freebsd.org/threads/sndiod-enable.62892/#post-363265).


### Staying up to date

#### Setting up cron to fetch updates nightly

Pull in updates every night at `03:00` per
[`portsnap(8)`](https://www.freebsd.org/cgi/man.cgi?sektion=0&manpath=FreeBSD%2013.0-RELEASE&arch=default&format=html&query=portsnap) and [`freebsd-update(8)`](https://www.freebsd.org/cgi/man.cgi?sektion=0&manpath=FreeBSD%2013.0-RELEASE&arch=default&format=html&query=freebsd-update).

Note that neither `portsnap cron` nor `freebsd-update cron` apply
updates. They only download updates.

	# cat <<EOF | crontab -
	> 0 3 * * * root /usr/sbin/portsnap cron
	> 0 3 * * * root /usr/sbin/freebsd-update cron
	> EOF

#### Updating the system and ports

When ready to update, issue these commands to apply changes to the ports
and source tree, as well as binary updates to the base system (I add
`fetch` just to be safe):

	# portsnap fetch update
	# freebsd-update fetch install
	# git -C /usr/src pull

If `freebsd-update fetch install` installs any updates,
`graphics/drm-kmod` needs to be rebuilt [per the FreeBSD
handbook](https://docs.freebsd.org/en/books/handbook/x11/#x-config-video-cards).

	# portmaster -f graphics/drm-kmod

Always check `/usr/ports/UPDATING` before upgrading any ports. Then,
upgrade.

	$ less /usr/ports/UPDATING
	# portmaster -a

Reboot.

	# reboot

## Parting words

Overall, I'm quite happy with the way the entertainment center turned
out. It's involved in the beginning (in great part due to my specific
desires/vision), but maintaining it isn't so bad. I definitely feel more
comfortable maintaining a *BSD system over a Linux system in the long
term (particularly OpenBSD, but FreeBSD as well), so this setup works
out well for me.

Eventually, I'd like to add in the ability to emulate and play games.
For now, Kodi is enough to quell my boredom.

## Additional resources

- [Video levels and color
  space](https://kodi.wiki/view/Video_levels_and_color_space). Helpful
  entry from the Kodi Wiki.
- [Calibration media for TV brightness, contrast,
  and so on](https://w6rz.net/), as mentioned in [this
  thread](https://www.avsforum.com/forum/139-display-calibration/948496-avs-hd-709-blu-ray-mp4-calibration.html).
  The OP deems it an 'alternate download link' (the other links are to
  Google Docs).
