# Open source operating system recommendations

[![A three panel comic strip from xkcd. It's titled "How Standards Proliferate" with a subheading of "See: A/C chargers, character encodings, instant messaging, etc." The first panel says "Situation: there are 14 competing standards." The second panel features two stick figures talking to one another, a man on the left and a woman on the right. The man says to the woman, "14?! Ridiculous! We need to develop one universal standard that covers everyone's use cases." The woman replies, "Yeah!" The third panel has a box in the top left hand corner that says, "Soon:", and the main text says, "Situation: There are 15 competing standards." ](/images/xkcd-standards.6975f55c09cec9a24ccb0185707d56892b881f9b1157c3e6d7ff61554d91ba94.2.png)](/images/xkcd-standards.6975f55c09cec9a24ccb0185707d56892b881f9b1157c3e6d7ff61554d91ba94.2.png)

The above [xkcd comic](https://xkcd.com/927/) illustrates the
difficulties of creating a universal standard, and why it often only
results in yet another competing standard instead. This is a broadly
applicable lesson that explains the wide array of open source operating
systems available today.

One of the most common experiences that someone exploring alternative
operating systems on their own may encounter is a feeling of being
overwhelmed by the sheer amount of choice available. While I have no
real solution for this feeling, I hope that my own "best of kind" list
can be useful regardless.

## Table of Contents

<!-- mtoc-start -->

- [Resources](#resources)
- [User friendly and just works](#user-friendly-and-just-works)
- [Innovative and for power users](#innovative-and-for-power-users)
- [Reasonably secure and paranoid](#reasonably-secure-and-paranoid)
- [Run the latest software and do it your way](#run-the-latest-software-and-do-it-your-way)
- [Customize everything and learn a lot about Linux](#customize-everything-and-learn-a-lot-about-linux)
- [The minimal Unix-like cousin of Arch](#the-minimal-unix-like-cousin-of-arch)
- [Simple, stable, and follows the Unix philosophy](#simple-stable-and-follows-the-unix-philosophy)
- [A secure mobile operating system](#a-secure-mobile-operating-system)
- [Reproducible, declaratively built OS](#reproducible-declaratively-built-os)

<!-- mtoc-end -->

## Resources

Before my recommendations, here are some resources that I find helpful:

- [Librehunt](https://librehunt.org/) first explains in simple terms the
  concepts that anyone would need to know to make an informed decision
  about Linux. After that, the second part involves a quiz so that
  Librehunt can suggest relevant Linux distributions.
- [Distrochooser](https://distrochooser.de/) is similar to Librehunt in
  that it uses the answers to a quiz to recommend Linux distributions,
  except I'd say the target audience is more technically inclined.
- [Distrowatch](https://distrowatch.com/) is a more visually busy and
  dense website, to say the least, but it's a decent tool to search
  operating systems by category, discover new ones, or read a little
  about what's happening in the Linux world. It's good to be aware of
  the way they measure popularity: the numbers by each distribution is
  how many times that page has been visited on the Distrowatch website
  in the last 6 months.
- [Repology](https://repology.org/) offers a way to search the software
  repositories of many different open source operating systems at once.

## User friendly and just works

There are many options in this space, but a great all-around pick that I
always fall back to is [Linux Mint](https://linuxmint.com/). The
Cinnamon edition stands out in particular, as it's user friendly and
feels polished, yet it also empowers the user. The large, helpful
community is exactly what someone new to Linux will appreciate. I feel
confident pointing to Linux Mint for this use case, as it showcases the
unique strengths of Linux in an accessible way to new users.

## Innovative and for power users

[Fedora](https://fedoraproject.org/) is backed by Red Hat, the largest
Linux company in the world. It offers many compelling features out of
the box, such as the SELinux mandatory access control system and the
copy-on-write filesystem known as btrfs. If taking advantage of new
Linux features and keeping a finger on its pulse is important to you,
Fedora is a sensible choice.

## Reasonably secure and paranoid

[Qubes OS](https://www.qubes-os.org) is a security-oriented operating
system designed to separate different aspects of your digital life into
virtual machines, also called qubes. The idea is to compartmentalize
everything so that if one qube is compromised, the rest of the system
won't be affected. Qubes OS integrates [Whonix](https://www.whonix.org/)
which is a huge win for privacy. I highly recommend it to anyone that
prioritizes the security of their machine above all else.

## Run the latest software and do it your way

[Arch](https://archlinux.org/) is often the first advanced Linux
distribution that people try. A distribution installed from the
command-line, Arch aims to provide the newest releases of software in
its repositories. The Arch wiki is an excellent source of information
and a massive selection of software can be installed via the Arch User
Repository (AUR). Arch offers a middle ground between customization and
practicality that many people appreciate.

## Customize everything and learn a lot about Linux

[Gentoo](https://www.gentoo.org/) prioritizes extensive customization
and choice. Portage (Gentoo's package management system) exposes a
wealth of options to the user, allowing them to easily adjust the
compile time options of software they install through something called
"USE flags." In addition, components like the system logger and init
system are chosen during the installation process, which also takes
place at the command-line. Gentoo's wiki and its knowledgeable yet
friendly community make it one of the best ways to learn about the deep
inner workings of Linux.

## The minimal Unix-like cousin of Arch

[Void](https://voidlinux.org/) falls somewhere between Arch and Gentoo
in my eyes. It feels more Unix-like than Arch, yet it doesn't lean as
strongly into customization as Gentoo. Void's package manager (xbps),
init system (runit), and alternative libc support (musl) are major
selling points of the distribution. In general, I can see the logic
behind many of the decisions and design choices that the project makes.
For example, I think mandoc is an excellent manual page system, and Void
uses it by default.

## Simple, stable, and follows the Unix philosophy

[OpenBSD](https://www.openbsd.org/) is a BSD system that has a strong
focus on security, portability, simplicity, and correctness. OpenBSD
features some of the best documentation of any project I've used, and it
introduced me to a lot of software that I still admire to this day. For
me, it's unmatched on the server side due to OpenBSD's simplicity and
secure by default approach. Development moves in a more deliberate,
controlled manner compared to Linux, which moves rapidly and more
chaotically. [Here are some more of my thoughts on
OpenBSD](/why-openbsd.html).

## A secure mobile operating system

[GrapheneOS](https://grapheneos.org/) is a privacy and security focused
version of Android, specifically for Google Pixel devices due to the
merits of that hardware. Some of the unique advantages of GrapheneOS are
sandboxed Google Play services, extensive system hardening, and secure
replacement applications. In terms of mobile operating systems, I know
of nothing more secure.

## Reproducible, declaratively built OS

[NixOS](https://nixos.org) presents a different method of system
management: describing your desired system in a configuration file and
then issuing a single command to build it. There are definite advantages
to this approach and [I've written more about NixOS
here](/nixos-pros-cons.html).
