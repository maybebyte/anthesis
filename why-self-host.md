# Why self-host/use FLOSS?

People often don't understand why I choose to be my own provider and use
libre software when the payoff is, to them, about the same. Or why
I won't repair a Windows installation.

Libre software has these benefits among others:

- Free as in freedom and free as in free beer (though you should donate
  to a project if you find it useful).
- Libre software is collaborative. Bugs are reported, pull requests are
  made, and the software is better for everyone as a result. Even those
  that aren't developers.
- Transparent. The behavior of a given program can be verified;
  consequently, FLOSS can be more private and secure since others
  review the source code.
- More likely to adhere to the [Unix
  philosophy](https://web.mit.edu/6.055/old/S2009/notes/unix.pdf).
- People in the community volunteer their time to help others in need.
- Unmaintained software can later be revived because the source code is
  available.
- Old hardware is still viable many years later--no more planned obsolescence
  and forced upgrades.
- Some of the free software people write is really cool and results from
  enthusiasm, not a desire for profit.

Contrast with [proprietary
software](https://www.gnu.org/proprietary/proprietary.en.html):

- DRM and the power differential that exists between those that provide
  a service and those that use it means you usually don't own anything
  in the undiluted sense of the word. It can be taken away from you on
  a whim, or you can get locked out if you refuse to comply with
  unreasonable terms of service.
- Deliberately incompatible (try moving photos from macOS/iOS to
  a device outside Apple's ecosystem).
- No say in the development process. Users barely have a voice in
  general.
- Surveillance is commonplace and it's harder to tell what exactly
  a program is doing. [Both Apple and Microsoft cooperate with the
  NSA](/images/Prism_slide_5.jpg).
- Planned obsolescence and forced upgrades.
- Censorship.
- Proprietary software is developed with the express purpose of turning
  a profit. Large companies tend to turn a blind eye to flagrant
  violations of ethics and freedom if they further that end.
- Misleads or takes advantage of users.
- Any funds that go toward proprietary software
  perpetuate the aforementioned problems and indicate to companies that
  they can get away with doing unethical things.

In saying all of this, I'm not trying to be negative (though any honest
account of proprietary software and the companies that produce it will
likely be negative, sadly). Instead, I'm outlining the differences so
I can drive this point home: when you run proprietary software, you're
the product.

You can regain your freedom by exchanging software that violates it for
software that respects it (Libreoffice instead of Microsoft Office,
Firefox instead of Google Chrome, etc). Bear in mind that this process
isn't all or nothing. Even exchanging one or two programs makes
a world of difference.

If you're interested, check out [my guide on
self-hosting](/self-host-guide.html).

# Stuff I self-host

**DNS Sinkhole**

[Pi-hole](https://pi-hole.net/) is one of the most popular uses for
a Raspberry Pi. It acts as a DNS sinkhole for ads and telemetry (meaning
that ads and telemetry are blocked for any device that connects to the network).

**Entertainment Center**

1. [Retropie](https://retropie.org.uk/) is a fantastic project. I grew
   up with many of the games it supports so it caters to my nostalgia,
   and shaders only serve to further improve the experience. The
   Argon ONE (a nice case) makes it feasible to overclock the thermally
   challenged Raspberry Pi 4B.
1. An [MPD](https://www.musicpd.org/) instance is accessible within my
   LAN so I can play music on the speakers without toil.
1. [Kodi](https://kodi.tv/) is also on here for my boyfriend.

For all devices running Linux with MMC storage, I prefer F2FS, otherwise
known as the Flash-Friendly File System.
