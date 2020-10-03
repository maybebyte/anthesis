# Why self-host/use FLOSS?

People often don't understand why I choose to be my own provider when
the payoff is, to them, about the same.

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
  philosophy](https://en.wikipedia.org/wiki/Unix_philosophy).
- People in the community volunteer their time to help others in need.
- Unmaintained software can later be revived because the source code is
  available.
- Old hardware is still viable many years later--no more forced upgrades
  or planned obsolescence.
- Some of the free software people write is really cool and results from
  enthusiasm, not a desire for profit.

Contrast with [proprietary
software](https://www.gnu.org/proprietary/proprietary.en.html):

- DRM means you don't truly own anything. It can be taken away from you
  on a whim.
- Incompatible (try moving photos from macOS/iOS to a device outside
  Apple's ecosystem).
- No say in the development process.
- Surveillance is commonplace and it's harder to tell if it's
  happening. [Both Apple and Microsoft cooperate with the NSA](/images/Prism_slide_5.jpg).
- Planned obsolescence and forced upgrades.
- Censorship.
- Proprietary software is developed with the express purpose of turning
  a profit and large companies often turn a blind eye to flagrant
  violations of ethics and freedom if they further that end.
- Often misleads or takes advantage of users.
- A power differential exists between developers and end users; comply
  with their terms or lose the right to use that software.
- Any funds that go toward proprietary software
  perpetuate the aforementioned problems and indicate to companies that
  they can get away with doing unethical things.

When you run proprietary software, you're the product. You can regain
your freedom by exchanging software that violates it for software that
respects it (Libreoffice instead of Microsoft Office, Firefox instead of
Google Chrome, etc). Bear in mind that it doesn't have to be all or
nothing, even exchanging one or two programs makes a difference.

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
