# Why self-host/use FLOSS?

People often don't understand why I choose to be my own provider when
the payoff is, to them, about the same.

Libre software has these benefits among others:

- Customizable. You can do whatever you want with the software.
- Free as in freedom and free as in free beer (though you should donate
  to a project if you find it useful).
- The software can be redistributed/improved/studied.
- Collaborative. You can report bugs to developers or contribute and the
  software will be better for everyone as a result.
- Quality and passion. The impetus for releasing FLOSS is
  different. Writing libre software is a labor of love and people do it
  because they want to solve a problem.
- Often more private and secure due to code review.
- Transparent--libre software isn't trying to hide anything because the
  source code is publicly available.
- More likely to adhere to the [Unix
  philosophy](https://en.wikipedia.org/wiki/Unix_philosophy).
- People in the community volunteer their time to help others in need.
- Unmaintained software can later be revived.
- Old hardware is still viable. You're not forced to upgrade every few
  years.
- Some of it is just plain cool.

Contrast with [proprietary
software](https://www.gnu.org/proprietary/proprietary.en.html):

- DRM means you don't truly own anything, you can lose it at any time
  and companies use that to their advantage.
- Incompatible (try moving photos from macOS/iOS to a device outside
  Apple's ecosystem).
- You have no say in the development process.
- Surveillance is commonplace and it's harder to tell if it's
  happening. Both Apple and Microsoft cooperate with the NSA.
- Planned obsolescence.
- Censorship.
- Usually overengineered or 'bloated.' Proprietary software is developed
  with the express purpose of making money and many large companies
  don't care about ethics or freedom.
- Often deceives or manipulates users.
- A power differential exists between developers and end users; comply
  with their terms or lose the right to use that software.

In the end, you're the product when you run proprietary software.

Migration can be difficult (which is intentional, DRM is a method of
locking users in to an ecosystem). It doesn't help that proprietary
software is used by friends, work, and school, or sometimes required by
the last two. Despite that, I highly encourage you to explore free
alternatives to proprietary software you use.

Bear in mind that the libre lifestyle doesn't have to be all or nothing.
Exchange proprietary programs for ones that respect your freedom as you
feel comfortable (Libreoffice instead of Microsoft Office, Firefox
instead of Google Chrome, etc) and you'll be better for it.

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