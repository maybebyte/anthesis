# Why OpenBSD?

[![The OpenBSD logo with the mascot, Puffy the pufferfish, above it.](/images/openbsd-logo.png "Puffy is one of my favorite mascots.")](/images/openbsd-logo.png)

Formerly, my thoughts on [OpenBSD](https://www.openbsd.org/) were
scattered around my website. I'd allude to its strengths when needed.
However, that approach made my argumentation feel disjointed as a
result. Overall, it seems more sensible to have a central place to talk
about these things that can be linked to from elsewhere.

## Why not OpenBSD?

Firstly, I'd like to bring up the 'dealbreakers.' I wouldn't recommend OpenBSD to those that:

- Dislike reading/are unwilling to learn.
- Prioritize performance above all else.
- Desire a powerful filesystem like ZFS.
- Want all the latest features.
- Need every task or detail to be abstracted away graphically.
- Want it to work like `$PREVIOUS_OS`.

If these aren't things that align with a given use case, maybe
[Librehunt](https://librehunt.org/) will be of more avail. Otherwise,
continue on.

## Simplicity

When I say simplicity, I mean simplicity from a software
design/development perspective. OpenBSD follows the [Unix
philosophy](https://web.mit.edu/6.055/old/S2009/notes/unix.pdf) and
consciously avoids feature creep. There aren't as many bells and
whistles compared to other operating systems and that's good. That means
there's less to sift through if something breaks.

## Less decision paralysis

One of Linux's strengths is also a grave weakness: the abundance of
choice. Deciding what implementation to use for a mail/web/DNS/NTP
server is a task in itself, as there are many out there.

With OpenBSD, one already has a sane, powerful, and secure suite of
software to choose from, also known as the [base
system](https://why-openbsd.rocks/fact/base-system-concept/). For
instance, a web server with HTTPS and automated certificate renewal can
be had with [`httpd(8)`](https://man.openbsd.org/httpd),
[`acme-client(1)`](https://man.openbsd.org/acme-client), and
[`cron(8)`](https://man.openbsd.org/cron), all without installing any
additional software.

See [OpenBSD's "innovations"
page](https://www.openbsd.org/innovations.html) for more cool software
and ideas developed by the OpenBSD project. Did you know that
[OpenSSH](https://www.openssh.com/) is an OpenBSD project?

## Great documentation

OpenBSD feels transparent and comprehensible. Between the FAQ, man
pages, and mailing lists, as well as other resources like
`/etc/examples` and `/usr/local/share/doc/pkg-readmes`, the user isn't
lacking in ways to understand how the system works under the hood. An
OpenBSD installation is a didactic environment well-suited to anyone
with a DIY attitude.

## Security

Of course, no discussion of OpenBSD's strengths would be complete
without mention of [its focus on
security](https://www.openbsd.org/security.html).

One example I like, albeit one not strictly focused on the base system,
is how Firefox and Tor Browser are packaged with
[`pledge(2)`](https://man.openbsd.org/pledge) and
[`unveil(2)`](https://man.openbsd.org/unveil) in mind. Speaking to the
latter system call, there's no reason these browsers should be able to
read `~/.ssh` or `~/.gnupg`, so they can't. They can only interact with
whitelisted paths (with permission to read, write, execute, create, or
any combination thereof, depending on what's stipulated). As a result,
the amount of damage a malicious extension or browser exploit could
wreak is much less than usual.

## Privacy

`kern.video.record` and `kern.audio.record` are both set to `0` by
default, meaning that no video or audio can be recorded without
permission.

## Stability

I mean this both in terms of system stability and how fast things
change. A constantly changing system is a nightmare to maintain for
system administrators.

Users can depend on a new release being made available about once every
6 months. Every new release comes with documentation on changes made and
how to upgrade, which is a painless process with the
[`sysupgrade(8)`](https://man.openbsd.org/sysupgrade) tool.

## Sane defaults

OpenBSD is certainly configurable, but the project's attitudes toward
knobs is different from some others. OpenBSD tries to set good
defaults that work for everyone in the hopes that people won't need to
fiddle around much (the more someone who doesn't totally understand what
they're doing changes a system, the more likely they are to break
something).

Unlike many minimal Linux distributions, time synchronization, cron, log
rotation, a stateful packet filter/firewall, and local mail delivery are
all enabled by default on a new OpenBSD installation.

## Versatile

OpenBSD makes a good OS for both the desktop and the server, at least
for my needs.

## Other resources

- [Why OpenBSD rocks](https://why-openbsd.rocks/fact/)
- [awesome-openbsd](https://github.com/ligurio/awesome-openbsd)
- [Roman Zolotarev's website](https://rgz.ee/)
- [Solene's website](https://dataswamp.org/~solene/)
