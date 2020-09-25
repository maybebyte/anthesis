# Why self-host/use FLOSS?

People often don't understand why I choose to be my own provider when
the payoff is, to them, about the same.

Libre software has these benefits among others: a)
customizability/control b) privacy/security (hiding source code is
security by obscurity, a demonstrably ineffective practice) c)
a collaborative development process that emphasizes quality over profit
d) more likely to conform to the [UNIX
philosophy](https://en.wikipedia.org/wiki/UNIX_philosophy).

Contrast with [proprietary
software](https://www.gnu.org/proprietary/proprietary.en.html), where
you can lose everything tied to an account at a whim, where
surveillance, planned obsolescence, incompatibility, censorship, and
deception are the norm, where a power differential exists between
developers and end users. You're the product when you run proprietary
software.

Migration can be difficult. That difficulty is intended, as DRM is meant
to lock you in. It doesn't help that proprietary software is used by
friends, work, and school, or even required by the last two. Despite
that, I highly encourage you to explore free alternatives to proprietary
software you use. The libre lifestyle doesn't have to be all or nothing;
switch things out as you feel comfortable, like Google Chrome for
Firefox, and you'll be better for it.

If you're interested, check out [my guide on
self-hosting](/self-host-guide.html).

# Stuff I self-host

**DNS Sinkhole**

[Pi-hole](https://pi-hole.net/) is one of the most popular uses for
a Raspberry Pi. It acts as a DNS sinkhole for ads and telemetry and
works on devices you may not expect (smart TVs, to name one).

**Entertainment Center**

[Retropie](https://retropie.org.uk/) is a fantastic project. I grew up
with many of the games it supports so it caters to my nostalgia. The
Argon ONE makes it feasible to overclock the thermally challenged
Raspberry Pi 4B.

In addition, I put [Kodi](http://kodi.tv/) on the same machine as
Retropie for my boyfriend. I prefer SSH + mpv to play media on the TV as
it's a more minimal solution.

For all devices running Linux with MMC storage, I prefer F2FS, otherwise
known as the Flash-Friendly File System.
