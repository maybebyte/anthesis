# Building an OpenBSD router using an APU4D4

_Tested on OpenBSD 6.8_

**NOTE** (2023-07-22): the [Accelerated Processing Unit (APU) platform
is end-of-life](https://pcengines.ch/eol.htm). This article may need
updating, though many principles still apply. Proceed with caution.

## Table of contents

<!-- mtoc-start -->

- [Foreword](#foreword)
- [Hardware](#hardware)
- [Download OpenBSD](#download-openbsd)
- [Install OpenBSD](#install-openbsd)
- [After installation](#after-installation)
- [WireGuard](#wireguard)

<!-- mtoc-end -->

## Foreword

Consumer routers are riddled with security problems. Between 1999 and
2017, researchers disclosed 600 Common Vulnerabilities and Exposures
(CVEs) for router software---and those represent only the public
vulnerabilities. The paper ["So You Think Your Router Is
Safe?"](https://repository.stcloudstate.edu/cgi/viewcontent.cgi?article=1067&context=msia_etds)
addresses this subject well.

Faced with this reality, and as someone who's caught the OpenBSD bug (or
pufferfish, same difference), I decided to build my own router. Here's
how I did it.

## Hardware

To buy an APU4D4 or similar, visit [PC Engines](https://pcengines.ch/).
Their boards come with [coreboot](https://www.coreboot.org/)
preinstalled and the experience has been great.

![APU4B4 board on a wooden surface (front
side).](/images/apu4b4_1_thumb.c18528fca0cba9ef4c3848c0f10fc6430be53fd2305f83197d02448a1b9f305e.2.png)

![APU4B4 board on a wooden surface (back
side).](/images/apu4b4_2_thumb.4847a17a1552db16c59c2e6f5063d3250c4d2e188f35ea0de4d999b8589029bd.2.png)

Include a [USB to DB9F serial
adapter](https://www.pcengines.ch/usbcom1a.htm) in your order, as you'll
need it for installation.

![USB to DB9F serial adapter on a wooden
surface.](/images/usbcom1a_thumb.ed1530b66afc03466606d66be7c67b728f4648652f57df7b269195ec731b6088.2.png)

[Consult the manual for assembly
instructions](https://pcengines.ch/pdf/apu4.pdf).

## Download OpenBSD

Download, verify, and flash the amd64 image that includes the file sets
`(installXX.img)` to a USB drive. [OpenBSD's FAQ covers
this](https://www.openbsd.org/faq/faq4.html).

## Install OpenBSD

Connect to the serial port. I run OpenBSD on my laptop, so I use
[`cu(1)`](https://man.openbsd.org/cu) for serial connections. The user
must belong to the `dialer` group to use
[`cua(4)`](https://man.openbsd.org/cua) devices.

Display the current user and their groups with
[`id(1)`](https://man.openbsd.org/id).

    $ id

Add the user to the `dialer` group if necessary with
[`usermod(8)`](https://man.openbsd.org/usermod).

    # usermod -G dialer [user]

Finally, connect to the serial port. This specifies the line to use
`(-l)` and the baud rate `(-s)`. The APU4D4 requires a baud rate of
`115200`.

    $ cu -l cuaU0 -s 115200

Remember to enter this at the boot prompt afterward to configure the
serial connection. The installer sets these later.

    boot> stty com0 115200
    boot> set tty com0
    boot> boot

From here, the FAQ provides enough information to complete the
installation. Check [the documentation for the relevant
architecture](https://www.openbsd.org/plat.html). In this case, consult
[the notes on amd64](https://www.openbsd.org/amd64.html).

## After installation

Complete the usual tasks (read
[`afterboot(8)`](https://man.openbsd.org/afterboot), check system mail,
etc.). After that, you need to implement several components:

- A [firewall, Dynamic Host Configuration Protocol (DHCP) server, and
  Domain Name System (DNS)
  server](https://www.openbsd.org/faq/pf/example1.html). See my
  [pf.conf](/src/sysadm/file/examples/openbsd/pf.conf.html).
- A way to connect to the Internet, which varies between providers. For
  some, you may need a Point-To-Point Protocol over Ethernet (PPPoE)
  connection. See [`pppoe(4)`](https://man.openbsd.org/pppoe).

You can also add these components:

- Many use cases require a [network bridge for Ethernet
  interfaces](https://www.openbsd.org/faq/faq6.html#Bridge). As of 6.9, I
  use [`veb(4)`](https://man.openbsd.org/veb) with good results.
- [IPv6](https://lipidity.com/openbsd/router/), depending on your use
  case and whether your Internet Service Provider (ISP) supports it.
- DNS sinkhole with [`unbound(8)`](https://man.openbsd.org/unbound), see
  [Creating a DNS sinkhole with Perl and unbound(8)](/dns-sinkhole.html).
- Authoritative DNS for devices on the home network with the special-use
  domain `home.arpa`, see [Local authoritative DNS on OpenBSD using
  dhcpd(8) and unbound(8)](/local-authoritative-dns.html).

Always give official OpenBSD documentation preferential treatment and
cross-reference it when using unofficial documentation. Keep it simple
and avoid changing settings unless you understand what they do.

## WireGuard

[Solene has a great article on
this](https://dataswamp.org/~solene/2021-10-09-openbsd-wireguard-exit.html).
