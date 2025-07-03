# Setting up a 4K Kodi box with sndio on FreeBSD

_Tested on FreeBSD 13.0-RELEASE_

## Table of contents

<!-- mtoc-start -->

- [Installation](#installation)
- [After installation](#after-installation)
  - [Setting up power management](#setting-up-power-management)
  - [Creating make.conf](#creating-makeconf)
  - [Checking out source code](#checking-out-source-code)
    - [Checking out the ports tree](#checking-out-the-ports-tree)
    - [Installing portmaster](#installing-portmaster)
    - [Checking out FreeBSD's source code](#checking-out-freebsds-source-code)
  - [Odds and ends before compiling Kodi](#odds-and-ends-before-compiling-kodi)
    - [Installing needed tools](#installing-needed-tools)
    - [Setting up doas.conf](#setting-up-doasconf)
    - [Entering a tmux session](#entering-a-tmux-session)
  - [Compiling Kodi](#compiling-kodi)
    - [Using portmaster to compile ports](#using-portmaster-to-compile-ports)
    - [Reviewing installation messages](#reviewing-installation-messages)
  - [Setting up a user environment for Kodi](#setting-up-a-user-environment-for-kodi)
    - [Creating the kodi user](#creating-the-kodi-user)
    - [Creating .xinitrc](#creating-xinitrc)
    - [Starting X](#starting-x)
  - [Starting Kodi automatically](#starting-kodi-automatically)
    - [Setting up gettytab](#setting-up-gettytab)
    - [Editing ttys](#editing-ttys)
    - [Ensuring X only starts in the correct terminal](#ensuring-x-only-starts-in-the-correct-terminal)
  - [Configuring the sound system](#configuring-the-sound-system)
    - [Bit-perfect](#bit-perfect)
    - [Not bit-perfect](#not-bit-perfect)
  - [Staying up to date](#staying-up-to-date)
    - [Setting up cron to fetch updates nightly](#setting-up-cron-to-fetch-updates-nightly)
    - [Updating the system and ports](#updating-the-system-and-ports)
- [Parting words](#parting-words)
- [Resources](#resources)

<!-- mtoc-end -->

## Installation

For brevity, this guide doesn't cover the FreeBSD installation process
in depth. The FreeBSD handbook [documents this
process](https://docs.freebsd.org/en/books/handbook/bsdinstall/).

The short version:

1. [Download an installation image for
   amd64](https://www.freebsd.org/where/).
1. Verify the image's checksum and GPG (GNU Privacy Guard) signature.
   Without this verification, you can't confirm the installation
   image's authenticity or detect tampering.
1. Flash the image to a USB drive.
1. Boot from the USB drive and complete the installation procedure.

## After installation

The post-installation setup becomes more specific here. This guide uses
ports instead of packages because Kodi lacks built-in
[sndio](https://sndio.org/) support by default. This choice makes the
post-installation phase more involved.

Log in to the freshly installed FreeBSD system and follow these steps.

### Setting up power management

Enable and start
[`powerd(8)`](https://www.freebsd.org/cgi/man.cgi?sektion=0&manpath=FreeBSD%2013.0-RELEASE&arch=default&format=html&query=powerd)
for power management. This reduces power consumption when the
entertainment center sits idle.

    # sysrc powerd_enable="YES"
    # service powerd start

### Creating make.conf

To make changes take effect immediately, set up
[`make.conf(5)`](https://www.freebsd.org/cgi/man.cgi?sektion=0&manpath=FreeBSD%2013.0-RELEASE&arch=default&format=html&query=make.conf)
before compiling anything.

To stay current, [my make.conf lives in
git](/src/sysadm/file/examples/freebsd/poudriere/make.conf.html), but
don't copy it without understanding it first. The configuration includes
everything needed to compile with sndio, LibreSSL, and Intel Quick Sync
Video support.

### Checking out source code

#### Checking out the ports tree

[See the FreeBSD handbook entry on ports for more
details](https://docs.freebsd.org/en/books/handbook/ports/#ports-using).

    # portsnap fetch extract

#### Installing portmaster

Install a ports management tool. For simplicity, this guide uses
`ports-mgmt/portmaster`. While `ports-mgmt/poudriere` also works well,
teaching poudriere exceeds this guide's scope. Portmaster gets the job
done.

    # make -C /usr/ports/ports-mgmt/portmaster install clean

#### Checking out FreeBSD's source code

Install `git`, as the source tree checkout requires it. The `git-tiny`
flavor works well.

    # portmaster devel/git@tiny

[Check out the source
tree](https://docs.freebsd.org/en/books/handbook/cutting-edge/#updating-src-obtaining-src).
Building `graphics/drm-kmod` requires the source tree.

    # git clone https://git.freebsd.org/src.git -b releng/13.0 /usr/src

### Odds and ends before compiling Kodi

#### Installing needed tools

Install a few tools to make the build process more manageable before
building Kodi. `sysutils/tmux` proves essential because you can detach
from a tmux session and log out while portmaster builds, then later log
in and reattach to check the build progress.

`security/doas` provides a more minimalist method of privilege
elevation.

Consider installing a text editor and shell if desired. I like
`editors/neovim` and `shells/oksh`.

    # portmaster sysutils/tmux security/doas

#### Setting up doas.conf

If you installed `security/doas`, set up
[`doas.conf(5)`](https://man.openbsd.org/doas.conf). Since FreeBSD
currently lacks persistence support, adding `nopass` improves usability.

    # echo 'permit nopass :wheel' >/usr/local/etc/doas.conf

#### Entering a tmux session

This step matters for the next section. The one-liner below checks
whether the current user has a tmux session open. If not, it first tries
to attach to an existing session, and creates a new session if that
fails.

    $ [ -z "${TMUX}" ] && { tmux attach || tmux; }

### Compiling Kodi

#### Using portmaster to compile ports

Now compile Kodi.

Note: if you don't want ports configuration beyond what make.conf
specifies, prepend `BATCH=1` to the below command. I recommend at least
reviewing the options available for `multimedia/ffmpeg` and
`multimedia/kodi` with `make config`.

Remember to install packages needed for [Hardware video
acceleration](https://wiki.archlinux.org/title/Hardware_video_acceleration).
For the Latte Panda Delta, these packages include
`multimedia/libva-intel-media-driver` and `multimedia/libvdpau-va-gl`.

    # portmaster audio/sndio graphics/drm-kmod multimedia/libva-intel-media-driver \
    > multimedia/libvdpau-va-gl x11/xorg misc/unclutter-xfixes multimedia/kodi \
    > multimedia/kodi-addon-inputstream.adaptive

After giving portmaster permission to build everything, detach from the
tmux session (`CTRL-b d` by default. Or create a second window with
`CTRL-b c` and issue `tmux detach`). Then, close the SSH connection and
take a fifteen-minute break.

After the initial break, SSH back in and `tmux attach` to check for
early errors that need attention. Waiting hours only to discover that
portmaster encountered an early error and stopped building is
frustrating.

Now, relax---compiling Kodi and Xorg on a single board computer takes
time.

#### Reviewing installation messages

Review installation messages to check for needed interventions.

    $ pkg query '%M' | less

### Setting up a user environment for Kodi

#### Creating the kodi user

Create a separate user for Kodi (named `kodi` here). Add the `kodi` user
to the `video` group.

    # adduser

If you didn't add `kodi` to the `video` group during user creation, go
ahead and fix it now:

    # pw groupmod video -m kodi

After that, log in as the `kodi` user.

#### Creating .xinitrc

Create `/home/kodi/.xinitrc` to configure part of the startup process
for the graphical environment.

The `xset` commands prevent interference with Kodi's screen blanking
mechanisms. `unclutter` hides the cursor when idle. By default, the
cursor stays invisible during ordinary usage, but if you bump a pointer
device, it sticks around. `unclutter` helpfully hides it again after a
short period of inactivity.

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

If X starts successfully, log out of the `kodi` user and back in to the
user with root access.

### Starting Kodi automatically

#### Setting up gettytab

Having Kodi start automatically on boot can help. This requires the
`kodi` user to log in automatically. To enable this, append some
configuration to
[`gettytab(5)`](https://www.freebsd.org/cgi/man.cgi?sektion=0&manpath=FreeBSD%2013.0-RELEASE&arch=default&format=html&query=gettytab).

    # cat <<EOF >>/etc/gettytab
    > # autologin kodi
    > A|Al|Autologin console:\
    >	:ht:np:sp#115200:al=kodi
    > EOF

#### Editing ttys

Edit
[`ttys(5)`](https://www.freebsd.org/cgi/man.cgi?query=ttys&apropos=0&sektion=0&manpath=FreeBSD+13.0-RELEASE&arch=default&format=html)
to match the following configuration.

    # Virtual terminals
    #ttyv1	"/usr/libexec/getty Pc"	xterm	onifexists	secure
    ttyv1	"/usr/libexec/getty Al"	xterm	onifexists	secure

#### Ensuring X only starts in the correct terminal

As the `kodi` user, append this check to `/home/kodi/.profile`. The
check makes X start only in the correct terminal and prevents X from
starting if already running.

    $ cat <<EOF >>~/.profile
    > if [ -z "${DISPLAY}" ] && [ "$(tty)" = '/dev/ttyv1' ]; then
    > 	exec startx
    > fi
    > EOF

Finally, reboot the system.

    # reboot

### Configuring the sound system

If everything works correctly, configure the sound system. Set the
default device with
[`sysctl(8)`](https://www.freebsd.org/cgi/man.cgi?sektion=0&manpath=FreeBSD%2013.0-RELEASE&arch=default&format=html&query=sysctl)
if needed (check `/dev/sndstat` for available devices).

    # sysctl hw.snd.default.unit=1 # needed for HDMI in this case

Now, decide whether to use bit-perfect mode and consult the relevant
section below. Note that the ["Sync playback to
display"](https://kodi.wiki/view/Settings/Player/Videos#Sync_playback_to_display)
option in Kodi conflicts with bit-perfect audio. It resamples both video
and audio to match the display's refresh rate.

#### Bit-perfect

To use bit-perfect mode, apply two `sysctl` tweaks. This example uses
the first device, but check which device needs tweaking.

    # sysctl dev.pcm.1.bitperfect=1
    # sysctl hw.snd.maxautovchans=0

#### Not bit-perfect

Change `hw.snd.feeder_rate_quality` from its default value of `1`.
According to
[`sound(4)`](https://www.freebsd.org/cgi/man.cgi?sektion=0&manpath=FreeBSD%2013.0-RELEASE&arch=default&format=html&query=sound),
the default linear interpolation doesn't provide antialiasing filtering.
I prefer to start with the highest resampling quality possible and lower
the value if needed.

    # sysctl hw.snd.feeder_rate_quality=4

Remember that regardless of which mode you select, to make sysctl tweaks
permanent, you must edit
[`sysctl.conf(5)`](https://www.freebsd.org/cgi/man.cgi?sektion=0&manpath=FreeBSD%2013.0-RELEASE&arch=default&format=html&query=sysctl.conf)
accordingly.

[Note that sndiod isn't needed in either
case](https://forums.freebsd.org/threads/sndiod-enable.62892/#post-363265).

### Staying up to date

#### Setting up cron to fetch updates nightly

Pull in updates every night at 03:00 using
[`portsnap(8)`](https://www.freebsd.org/cgi/man.cgi?sektion=0&manpath=FreeBSD%2013.0-RELEASE&arch=default&format=html&query=portsnap)
and
[`freebsd-update(8)`](https://www.freebsd.org/cgi/man.cgi?sektion=0&manpath=FreeBSD%2013.0-RELEASE&arch=default&format=html&query=freebsd-update).

Note that neither `portsnap cron` nor `freebsd-update cron` applies
updates. They only download updates.

    # cat <<EOF | crontab -
    > 0 3 * * * root /usr/sbin/portsnap cron
    > 0 3 * * * root /usr/sbin/freebsd-update cron
    > EOF

#### Updating the system and ports

When ready to update, run these commands to apply changes to the ports
and source tree. They also apply binary updates to the base system.

    # portsnap fetch update
    # freebsd-update fetch install
    # git -C /usr/src pull

If `freebsd-update fetch install` installs any updates, rebuild
`graphics/drm-kmod` [per the FreeBSD
handbook](https://docs.freebsd.org/en/books/handbook/x11/#x-config-video-cards).

    # portmaster -f graphics/drm-kmod

Always check `/usr/ports/UPDATING` before upgrading any ports. Then,
upgrade.

    $ less /usr/ports/UPDATING
    # portmaster -a

Reboot the system.

    # reboot

## Parting words

The entertainment center works well once configured. Setup proves
involved initially (due to my specific requirements and preferences),
but maintenance stays manageable.

## Resources

- [Video levels and color
  space](https://kodi.wiki/view/Video_levels_and_color_space). Helpful
  entry from the Kodi Wiki.
- [Calibration media for TV brightness, contrast, and other
  settings](https://w6rz.net/), as mentioned in [this
  thread](https://www.avsforum.com/forum/139-display-calibration/948496-avs-hd-709-blu-ray-mp4-calibration.html).
  The original poster provides this as an alternate download link (other
  links point to Google Docs).
