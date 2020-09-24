# Pros and cons of NixOS

I've experimented with many operating systems over the years. Even
though I chose OpenBSD in the end, NixOS was a strong contender and my
daily driver for a while.

Note that I won't write about every single aspect of these systems, as
that'd duplicate existing documentation. Anyway, let's get into the
advantages of NixOS.

## Pros

If you've used a Unix-like OS before, chances are that NixOS isn't what
you'd expect. While many Linux distributions are essentially the same
thing with a different paint of coat (certainly they don't differ as
much as the BSDs), the fact NixOS is a Linux distribution only says so
much about it in reality.

One of the most important differences to understand is that in NixOS,
you modify your system by editing a configuration file. What do I mean
by this?

Under the imperative paradigm of system management, you'd run something
similar to this to enable OpenSSH:

    # apt install openssh-server
    # systemctl enable ssh

Contrast this with a declarative system like NixOS, where you'd add
`services.sshd.enable = true;` to `/etc/nixos/configuration.nix` with
your favorite text editor followed by:

    # nixos-rebuild switch

This pulls in OpenSSH if it isn't installed and sets it up for you. As
you can see, maintaining a NixOS installation is an ongoing process of
describing and subsequently rebuilding your system. You might ask,
"What's the point of learning a whole new way to do things?"

The point is consistency and reproducibility. Sometimes it feels like
every program's configuration files use a different syntax. NixOS allows
you to configure everything with one language: Nix. When I realized this
meant I could configure fonts without XML, I was *sold*. It's the
difference between this:

    <?xml version='1.0'?>
    <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
    <fontconfig>
      <alias>
        <family>serif</family>
        <prefer>
          <family>Noto Serif</family>
        </prefer>
      </alias>
      <alias>
        <family>sans-serif</family>
        <prefer>
          <family>Noto Sans</family>
        </prefer>
      </alias>
      <alias>
        <family>monospace</family>
        <prefer>
          <family>Noto Mono</family>
        </prefer>
      </alias>
    </fontconfig>

And this:

    fonts.fontconfig.defaultFonts = {
      serif = [ "Noto Serif" ];
      sansSerif = [ "Noto Sans" ];
      monospace = [ "Noto Mono" ];
    };

I'd much rather write the second one, wouldn't you?

Rollbacks and atomic upgrades are also a part of NixOS. If one version
of the system doesn't boot, you can boot the last working configuration
(assuming the problem isn't related to the boot loader). In addition,
you'll probably still have a functioning system if the machine dies in
the middle of an upgrade.

Probably one of the most killer features for developers is
[`nix-shell`](https://nixos.org/manual/nix/stable/#sec-nix-shell). You
can create temporary, reproducible environments with whatever packages
you need to develop your application. Then, once you exit the shell,
those packages are no longer in your PATH. While virtual environments
aren't exclusive to NixOS, it's convenient to have a language agnostic
tool for this included with the system. `nix-shell` is more or less
limited to your imagination given that it uses the Nix language.

NixOS is self-documenting in a certain light. When a sysadmin retires
and someone else takes their place, the newcomer doesn't need to crawl
through `/etc` and take a shot in the dark as to how the OS is different
from a fresh installation (though hopefully someone would give the poor
bastard at least an outline). System configuration happens in one place,
`/etc/nixos`, and since a NixOS installation is an ongoing process of
describing the system you want, `/etc/nixos` is a living, breathing
record of the changes you've made. Because of its reproducible nature,
NixOS is a great choice for server farms.

One last pro: creating a custom live ISO to your specifications by
leveraging Nix is much more pleasant than doing it imperatively in my
experience.

Declarative configuration is visionary in some respects and in
principle, I like it a lot. Yet I switched to OpenBSD. Why?

## Cons

Many of the problems NixOS suffers aren't exclusive to it. That is to
say, some of these problems plague Linux in general. I look for
simplicity in an operating system (architectural simplicity, or KISS).
Simplicity is an area NixOS doesn't do so well in.

For instance, compare the tool NixOS uses to manage services,
[`systemctl(1)`](https://www.mankier.com/1/systemctl), with OpenBSD's
[`rcctl(8)`](https://man.openbsd.org/rcctl). This is just one
example. Other examples include the sound server (pulseaudio vs sndio),
method of privilege elevation (sudo vs doas), firewall (iptables vs pf),
and so on.

You might say, "What's wrong with features? Features are good."
Sometimes they are. Often they aren't. In fact, lacking unnecessary
features *is* a feature in my book because less code equates to less
potential for bugs and vulnerabilities. Large code bases are also harder
to maintain, understand, contribute to, and port over to other operating
systems.

The only viable boot loader for `/boot` encryption in Linux, GRUB,
doesn't handle decryption as elegantly as OpenBSD's boot loader does. In
OpenBSD, when you type in the wrong password, the boot loader gives you
instant feedback and you get to try again. [Here's what you get to deal
with when that happens in
GRUB](https://wiki.archlinux.org/index.php/Grub#GRUB_rescue_and_encrypted_/boot).

NixOS presents a fundamentally different way to manage a system and
while very powerful, it can also be very frustrating. When the 'magic'
behind the scenes stops working, it gets ugly fast. To the point that
while abstracting away things in Nix saves effort in some ways, it
creates more work in others.

There isn't a focus on being secure by default in NixOS like there is
with OpenBSD. As a sysadmin and someone who's a bit paranoid (hey, just
because I'm paranoid doesn't mean they aren't out to get me), I need my
system to have secure defaults. Security is often eschewed in favor of
new features because the reward for good security is 'nothing.' No
intrusions happen, no damage is sustained, and no services go down. In
other words, the benefit of good security is often more about what
doesn't happen rather than what does.

Documentation for NixOS is scattered and of varying quality, whereas
OpenBSD has consistently excellent documentation with its man pages and
FAQ.

## Verdict

Overall, while I really like the underlying philosophy behind NixOS,
OpenBSD suits my needs better. I run it wherever I can and I see myself
running it for a long time.

That said, NixOS certainly has its place and I still check in on the
project now and again to see what's new. Declarative languages are
compelling enough to me that I use xmonad, a window manager written and
configured in Haskell.
