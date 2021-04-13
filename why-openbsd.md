# Why OpenBSD?

[![The OpenBSD logo with the mascot, Puffy the pufferfish, above it.](/images/openbsd-logo.png "Puffy is one of my favorite mascots.")](/images/openbsd-logo.png)

Formerly, my thoughts on [OpenBSD](https://www.openbsd.org/) were
scattered around my website. I'd allude to its strengths when needed;
however, that approach made my argumentation feel disjointed as a
result. Overall, it seems more sensible to have a central place to talk
about these things that can be linked to from elsewhere.

## Why not OpenBSD?

Firstly, I'd like to bring up the 'dealbreakers.' I wouldn't recommend OpenBSD to those that:

- Dislike reading/are unwilling to learn. OpenBSD *will* require reading
  from time to time, it's just how it is.
- Prioritize performance above all else.
- Desire a powerful filesystem like ZFS.
- Want all the latest features.
- Need every task or detail to be abstracted away graphically.
- Get offended by terseness or being directed to relevant
  documentation when asking others for help. Generally speaking, the mailing lists
  are quite helpful, but there isn't a lot of hand-holding because
  those qualified to answer technical questions are likely busy with
  other projects, too.

If you remain unfettered by these, or at least aren't bothered by them
too much, continue on. Otherwise, perhaps
[Librehunt](https://librehunt.org/) will be of more avail.

## Simplicity

When I say simplicity, I mean architectural simplicity. OpenBSD follows
the [Unix
philosophy](https://web.mit.edu/6.055/old/S2009/notes/unix.pdf) and
consciously avoids feature creep. There aren't as many bells and
whistles compared to other operating systems and that's good! That means
there's less to sift through if something breaks.

## Less decision paralysis

One of Linux's strengths is also a grave weakness: the abundance of
choice. Deciding what implementation to use for a mail/web/DNS/NTP
server is a task in itself, as there are many out there. With OpenBSD,
one already has a sane, powerful, and secure suite of software to choose
from, also known as the [base
system](https://why-openbsd.rocks/fact/base-system-concept/). For
instance, a secure web server with automated certificate renewal can be
had with [`httpd(8)`](https://man.openbsd.org/httpd) and
[`acme-client(1)`](https://man.openbsd.org/acme-client), all without
installing any additional software.

See [OpenBSD's 'innovations'
page](https://www.openbsd.org/innovations.html) for more cool software
and ideas developed by the OpenBSD project. Did you know that
[OpenSSH](https://www.openssh.com/) is an OpenBSD project?

## Great documentation

OpenBSD feels transparent and comprehensible.  Between the FAQ, man
pages, and mailing lists, as well as other resources `(/etc/examples,
/usr/local/share/doc/pkg-readmes)`, OpenBSD gives one the tools to
understand any problems one may run into at a fundamental level. It's a
didactic environment well-suited to anyone with a DIY attitude.

## Security

Of course, no discussion of OpenBSD's strengths would be complete
without mention of [its focus on
security](https://www.openbsd.org/security.html). One great example is
[`pledge(2)`](https://man.openbsd.org/pledge) and
[`unveil(2)`](https://man.openbsd.org/unveil) support for Firefox and Tor
Browser. There's no reason these browsers should be able to read
`~/.ssh`, `~/.gnupg`, or private documents, so they can't. If they request a file
or capability outside of those that are whitelisted (`~/Downloads` being one
such whitelisted location), they'll fail. As a result, the amount of
damage a malicious extension or browser exploit can wreak is much less
than usual.

## Privacy

`kern.video.record` and `kern.audio.record` are both set to `0` by
default, meaning that no video or audio can be recorded without
permission.

## Hardware compatibility

This might sound strange. Surely Linux supports more hardware, no? The
key is that when OpenBSD supports a piece of hardware, it supports it
really well. Things that are often a struggle to set up on minimalist
Linux distributions are a piece of cake on OpenBSD. Power management,
CPU frequency scaling, and hibernate + suspend are easily handled by
[`apmd(8)`](https://man.openbsd.org/apmd), for example.

1. Enable the service.

        # rcctl enable apmd

1. Ensure that it'll be started in automatic performance adjustment mode.

        # rcctl set apmd flags '-A'

1. Finally, start the service.

        # rcctl start apmd

The only thing a bit 'weird' regarding hardware compatibility is that
binary blobs, needed sometimes for graphics and wireless, aren't
distributed with the installation images. Rather, they're automatically
detected and installed with
[`fw_update(1)`](https://man.openbsd.org/fw_update) upon first boot
given a functioning Internet connection. I'd say it's a
superior approach overall, as binary blobs are a security risk and using
a tool like this ensures only what's needed is installed.

## Stability

I mean this both in terms of system stability and how fast things
change. A constantly changing system is a nightmare to maintain for
system administrators.

## Other resources

- [Why OpenBSD rocks](https://why-openbsd.rocks/fact/)
- [awesome-openbsd](https://github.com/ligurio/awesome-openbsd)
- [Roman Zolotarev's website](https://rgz.ee/), which contains useful
  tutorials.
