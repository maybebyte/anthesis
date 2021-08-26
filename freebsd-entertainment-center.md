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

The short of it is as follows:

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

### Power management

Enable and start
[`powerd(8)`](https://www.freebsd.org/cgi/man.cgi?sektion=0&manpath=FreeBSD%2013.0-RELEASE&arch=default&format=html&query=powerd)
for power management. In theory, it should lower power consumption when
the entertainment center isn't doing much.

    # sysrc powerd_enable="YES"
    # service powerd start

### make.conf

1. To get it out of the way before compiling anything to ensure changes
   are immediately effective, set up
   [`make.conf(5)`](https://www.freebsd.org/cgi/man.cgi?sektion=0&manpath=FreeBSD%2013.0-RELEASE&arch=default&format=html&query=make.conf).

   In my case, there's no need to run binaries compiled on the Latte
   Panda Delta on other computers. Given this, I set
   `CPUTYPE?=goldmont-plus` to tell the compiler to optimize for the
   [Goldmont
   Plus](https://en.wikichip.org/wiki/intel/microarchitectures/goldmont_plus)
   microarchitecture (the Latte Panda Delta's microarchitecture).

   Note that `CPUTYPE?=goldmont-plus` shouldn't be added if you aren't
   using a Latte Panda Delta or something else with an appropriate CPU.
   Compiling binaries for a microarchitecture other than that of the
   machine trying to run them will end poorly.

   `MFX` is for [Intel Quick Sync
   Video](https://www.intel.com/content/www/us/en/architecture-and-technology/quick-sync-video/quick-sync-video-general.html)
   support in `multimedia/ffmpeg`, because the [Celeron
   N4100](https://ark.intel.com/content/www/us/en/ark/products/128983/intel-celeron-processor-n4100-4m-cache-up-to-2-40-ghz.html)
   (the Latte Panda Delta's CPU) supports Intel Quick Sync Video.

        # cat <<EOF >/etc/make.conf
        # performance related tweaks
        CPUTYPE?=goldmont-plus
        OPTIONS_SET=ASM CPU_OPTS LTO MFX OPTIMIZED_CFLAGS PGO
        #
        # documentation
        OPTIONS_SET+=DOCS EXAMPLES MANPAGES
        #
        # sndio
        OPTIONS_SET+=SNDIO
        #
        # graphical stuff
        OPTIONS_SET+=X11
        #
        # disable certain build options
        OPTIONS_UNSET=ALSA PLATFORM_WAYLAND PULSEAUDIO PULSE WAYLAND
        EOF

### Checking out source code

1. [Check out the ports tree](https://docs.freebsd.org/en/books/handbook/ports/#ports-using).

        # portsnap fetch extract

1. Install your ports management tool of choice. I find `ports-mgmt/portmaster` to
   be the most reliable, as `ports-mgmt/synth` appears to break builds that
   `portmaster` can cope with (probably some of the ports I use aren't
   written to handle parallel builds yet).

        # make -C /usr/ports/ports-mgmt/portmaster install clean

1. Install `git`, as it's needed for checking out the source tree. I
   like the `git-tiny` flavor.

        # portmaster devel/git@tiny

1. [Check out the source tree](https://docs.freebsd.org/en/books/handbook/cutting-edge/#updating-src-obtaining-src).
   This is required for building `graphics/drm-kmod`.

        # git clone https://git.freebsd.org/src.git -b releng/13.0 /usr/src

### Odds and ends before compiling Kodi

1. I like to install a couple of tools to make myself comfortable before
   building Kodi. In particular, I find `sysutils/tmux` to be essential,
   because one can detach from a `tmux` session and log out while
   `portmaster` is building, then later log in and reattach to check on
   the build.

   I definitely recommend `security/doas` as a simple method of
   privilege elevation.

        # portmaster sysutils/tmux security/doas

   Consider installing a text editor and a shell in addition to the
   aforementioned tools, if the options in the base system don't meet
   your needs. I like `editors/neovim` and `shells/oksh`.

1. If you've installed `security/doas`, set up
   [`doas.conf(5)`](https://man.openbsd.org/doas.conf). Since
   persistence is currently unsupported on FreeBSD, I add `nopass` for
   my own sanity.

        # echo 'permit nopass :wheel' >/usr/local/etc/doas.conf

1. Ensure you're inside a `tmux` session. It's important for the next
   part.

        $ [ -z "${TMUX}" ] && { tmux attach || tmux; }

   Simply put, this one-liner checks to see if the current user has a
   `tmux` session currently open. If not, it first tries to attach to an
   existing session, and creates a new session if that fails.

### Compiling Kodi

1. Alright, it's finally time to compile Kodi.

   Note: if you don't want to configure anything beyond what's already
   specified in `make.conf`, prepend `BATCH=1` to the below command. I
   recommend at least looking over the options available for
   `multimedia/ffmpeg` and `multimedia/kodi` with `make config`.

   Remember to install packages needed for [Hardware video
   acceleration](https://wiki.archlinux.org/title/Hardware_video_acceleration).
   In the Latte Panda Delta's case, they are
   `multimedia/libva-intel-media-driver` and
   `multimedia/libvdpau-va-gl`.

        # portmaster audio/sndio graphics/drm-kmod multimedia/libva-intel-media-driver multimedia/libvdpau-va-gl x11/xorg misc/unclutter-xfixes multimedia/kodi multimedia/kodi-addon-inputstream.adaptive

   After confirming that you want to build everything, detach from the
   `tmux` session (`CTRL-b d` is the default binding. Alternatively,
   create a second window with `CTRL-b c` and issue `tmux detach`).
   Then, kill the SSH connection and take a fifteen minute break or so.

   Once that initial fifteen minute break is over, SSH in and `tmux
   attach` to see if there were any errors encountered early on that
   need to be addressed. It's tedious to wait several hours only to
   realize that `portmaster` wasn't actually compiling anything for most
   of that time. Now that you've done so, you can truly relax, because
   compiling Kodi and Xorg on a single board computer isn't too speedy.

1. Review installation messages to check for needed interventions.

        $ pkg query '%M' | less

### Setting up a user environment for Kodi

1. Create a separate user for Kodi (I simply named mine `kodi`, and will
   refer to this separate user as such for the rest of this article). Make
   sure to add `kodi` to the `video` group.

        # adduser

  If you forgot to add `kodi` to the `video` group, no problem. Just
  issue the following:

        # pw groupmod video -m kodi

  After that, make sure to log in as `kodi`.

1. In order to initialize a graphical environment, we need to create
   `/home/kodi/.xinitrc`.

        $ cat <<EOF >~/.xinitrc
        . "${HOME}/.profile"
        xset s noblank
        xset s off
        xset -dpms
        unclutter &

        exec kodi
        EOF

   The `xset` commands are there to prevent interference with Kodi's
   screen blanking mechanisms. `unclutter` simply ensures that the
   cursor won't remain visible if idle (though the cursor shouldn't be
   visible during ordinary usage--it's merely a fallback in case that
   does happen, i.e., if a pointer device is accidentally bumped).

1. From a console (not SSH), start X.

        $ startx

  If it works, log out of `kodi` and back in to the user with root access.

### Starting Kodi automatically

1. You'll likely want Kodi to start automatically on boot. Some things
   are required for this to work: the first is that `kodi` needs
   to be automatically logged in. To address this, append some magic to
   [`gettytab(5)`](https://www.freebsd.org/cgi/man.cgi?sektion=0&manpath=FreeBSD%2013.0-RELEASE&arch=default&format=html&query=gettytab).

        # cat <<EOF >>/etc/gettytab
        # autologin kodi
        A|Al|Autologin console:\
          :ht:np:sp#115200:al=kodi
        EOF

1. Edit
   [`ttys(5)`](https://www.freebsd.org/cgi/man.cgi?query=ttys&apropos=0&sektion=0&manpath=FreeBSD+13.0-RELEASE&arch=default&format=html)
   to match below.

        # Virtual terminals
        #ttyv1  "/usr/libexec/getty Pc"         xterm   onifexists secure
        ttyv1   "/usr/libexec/getty Al"         xterm   onifexists secure

1. As `kodi`, edit `/home/kodi/.profile` to include this simple check.
Essentially, it makes sure X isn't running and that it would start X
in the correct tty before doing so.

        $ cat <<EOF >>~/.profile
        if [ -z "${DISPLAY}" ] && [ "$(tty)" = '/dev/ttyv1' ]; then
          exec startx
        fi
        EOF

1. Finally, cross your fingers and reboot.

        # reboot

### Configuring the sound system

If everything is good, it's time to configure the sound system. Set the
default device with
[`sysctl(8)`](https://www.freebsd.org/cgi/man.cgi?sektion=0&manpath=FreeBSD%2013.0-RELEASE&arch=default&format=html&query=sysctl)
if needed (inspect `/dev/sndstat` for a list of devices).

    # sysctl hw.snd.default.unit=1 # needed for HDMI in my case.

Now, decide whether or not you want to use bit-perfect mode and consult
the relevant section below.

#### Bit-perfect

In order to use bit-perfect mode, two `sysctl` tweaks are needed. Here,
I use the first device, but be sure to check what device needs to be
adjusted.

    # sysctl dev.pcm.1.bitperfect=1
    # sysctl hw.snd.maxautovchans=0

A sound server isn't desirable in this case, as `/dev/dsp` can't
be accessed concurrently in bit-perfect mode, so
[`sndiod(8)`](https://man.openbsd.org/sndiod) remains disabled. Kodi
will still use `sndio`, however, due to [behavior specific to the
FreeBSD
port](https://forums.freebsd.org/threads/sndiod-enable.62892/#post-363265).

#### Not bit-perfect

I recommend changing `hw.snd.feeder_rate_quality` from its default of
`1` (I've used the maximum value of `4` before without any issues, but
see what works for you).  According to
[`sound(4)`](https://www.freebsd.org/cgi/man.cgi?sektion=0&manpath=FreeBSD%2013.0-RELEASE&arch=default&format=html&query=sound),
the default of linear interpolation doesn't provide anti-aliasing
filtering.

    # sysctl hw.snd.feeder_rate_quality=4

Optionally, enable `sndiod`. Audio will function with the daemon running
or not. Though passing audio through `sndiod` first has some real perks,
like being able to monitor and record what other programs play, and
being able to tweak the volume of specific applications in addition to
the master volume.

    # sysrc sndiod_enable="YES"

Then, start the daemon.

    # service sndiod start

Remember that regardless of whether you chose bit-perfect mode or not,
if tweaks made with `sysctl` are to be permanent,
[`sysctl.conf(5)`](https://www.freebsd.org/cgi/man.cgi?sektion=0&manpath=FreeBSD%2013.0-RELEASE&arch=default&format=html&query=sysctl.conf)
must be modified accordingly.

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
