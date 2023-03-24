# Building an OpenBSD router using an APU4D4

*Tested on OpenBSD 6.8*

## Foreword

It's no secret that consumer routers have security problems (600 CVEs
between 1999 and 2017, and those were only the disclosed
vulnerabilities) as a result of poorly engineered software. The paper
["So You Think Your Router Is
Safe?"](https://repository.stcloudstate.edu/cgi/viewcontent.cgi?article=1067&context=msia_etds)
addresses this subject well.

Confronted with this reality, as someone who's been bitten by the
OpenBSD bug (or pufferfish, same difference), the solution that came to
mind was to build my own router. So I did, and what follows is how I
did it.

## Hardware

To purchase an APU4D4 or similar, visit [PC
Engines](https://pcengines.ch/). Their boards come with
[coreboot](https://www.coreboot.org/) preinstalled and so far it's been
a great experience.

![APU4B4 board on a wooden surface (front side).](/images/apu4b4_1_thumb.c18528fca0cba9ef4c3848c0f10fc6430be53fd2305f83197d02448a1b9f305e.2.png)

![APU4B4 board on a wooden surface (back side).](/images/apu4b4_2_thumb.4847a17a1552db16c59c2e6f5063d3250c4d2e188f35ea0de4d999b8589029bd.2.png)

Include a [USB to DB9F serial
adapter](https://www.pcengines.ch/usbcom1a.htm) in the purchase, as it's
needed for the installation.

![USB to DB9F serial adapter on a wooden surface.](/images/usbcom1a_thumb.ed1530b66afc03466606d66be7c67b728f4648652f57df7b269195ec731b6088.2.png)

[Consult the manual for assembly
instructions](https://pcengines.ch/pdf/apu4.pdf).

## Download OpenBSD

Download, verify, and flash the amd64 image that includes the file sets
`(installXX.img)` to a USB drive. [OpenBSD's FAQ covers
this](https://www.openbsd.org/faq/faq4.html).

## Install OpenBSD

Connect to the serial port. I run OpenBSD on my laptop, so I use
[`cu(1)`](https://man.openbsd.org/cu) for serial connections. Note that
the user must be part of the `dialer` group to use
[`cua(4)`](https://man.openbsd.org/cua) devices, so I'll briefly outline
how to make sure that's the case.

Display the current user and groups they belong to with
[`id(1)`](https://man.openbsd.org/id).

	$ id

Add the user to the `dialer` group if necessary with
[`usermod(8)`](https://man.openbsd.org/usermod).

	# usermod -G dialer [user]

Finally, connect to the serial port. This indicates the line to use
`(-l)` and the baud rate `(-s)`. The APU4D4 requires a baud rate of
`115200`.

	$ cu -l cuaU0 -s 115200

Please remember to enter this at the boot prompt afterward, to configure
the serial connection. Later on, the installer will set these.

	boot> stty com0 115200
	boot> set tty com0
	boot> boot

From here, the FAQ provides enough information to get through the rest
of the installation procedure. Be sure to look at [the documentation for
the relevant architecture](https://www.openbsd.org/plat.html). In this
case, that means to consult [the notes on
amd64](https://www.openbsd.org/amd64.html).

## After installation

Do the usual (in other words, read
[`afterboot(8)`](https://man.openbsd.org/afterboot), check system mail,
and so on). After that, there's a couple of things that must be
implemented.

- A [firewall, DHCP server, and DNS
  server](https://www.openbsd.org/faq/pf/example1.html). See my
  [pf.conf](/src/sysadm/file/examples/openbsd/pf.conf.html).
- A way to connect to the Internet, which can vary between providers.
  For some, a PPPoE connection may be needed. See
  [`pppoe(4)`](https://man.openbsd.org/pppoe).

Some other things that can be added:

- Many use cases require a [network bridge for ethernet
  interfaces](https://www.openbsd.org/faq/faq6.html#Bridge). As of 6.9,
  I'm using [`veb(4)`](https://man.openbsd.org/veb) with good results.
- [IPv6](https://lipidity.com/openbsd/router/), depending on use
  case and whether the ISP supports it.
- DNS sinkhole with [`unbound(8)`](https://man.openbsd.org/unbound), see
  [Creating a DNS sinkhole with Perl and
  unbound(8)](/dns-sinkhole.html).
- Authoritative DNS for devices on the home network with the special-use
  domain `home.arpa`, see [Local authoritative DNS on OpenBSD using
  dhcpd(8) and unbound(8)](/local-authoritative-dns.html).

As always, give official OpenBSD documentation preferential treatment
and cross-reference it when using unofficial documentation. Keep it
simple and if what a knob changes is unclear, don't change it.

## WireGuard

[Solene has a great article on
this](https://dataswamp.org/~solene/2021-10-09-openbsd-wireguard-exit.html).
