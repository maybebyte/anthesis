# Building an OpenBSD router using an APU4D4

*Tested on OpenBSD 6.8*

## Foreword

It's no secret that consumer routers have security problems (600 CVEs
between 1999 and January of 2017, and those were only the disclosed
vulnerabilities) as a result of poorly engineered software. The paper
["So You Think Your Router Is
Safe?"](https://repository.stcloudstate.edu/cgi/viewcontent.cgi?article=1067&context=msia_etds)
addresses this subject well.

Confronted with this reality, as someone who's been bitten by the
OpenBSD bug (or pufferfish, same difference), the solution that came to
mind was to build my own router.  So I did, and what follows is how I
did it.

## Hardware

To purchase an APU4D4 or similar, visit [PC
Engines](https://pcengines.ch/). Their boards come with
[coreboot](https://www.coreboot.org/) preinstalled and so far it's been
a great experience.

[![APU4B4 board on a wooden surface (front side).](/images/apu4b4_1_thumb.jpg)](/images/apu4b4_1.jpg)

[![APU4B4 board on a wooden surface (back side).](/images/apu4b4_2_thumb.jpg)](/images/apu4b4_2.jpg)

Include a [USB to DB9F serial
adapter](https://www.pcengines.ch/usbcom1a.htm) in the purchase, as it's
needed for the installation.

[![USB to DB9F serial adapter on a wooden surface.](/images/usbcom1a_thumb.jpg "It's a pretty nice cable, all in all.")](/images/usbcom1a.jpg)

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
  [pf.conf](/src/sysadm/file/examples/openbsd/pf.conf.router.html).
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
  [genblock](/src/sysadm/file/genblock.html).
- Authoritative DNS for devices on the home network with the special-use
  domain `home.arpa`, see [my article on the subject](/local-authoritative-dns.html).

As always, give official OpenBSD documentation preferential treatment
and cross-reference it when using unofficial documentation. Keep it
simple and if what a knob changes is unclear, don't change it.

## WireGuard

I like to use a VPN on my home network, as I don't trust my ISP and it's
a good fallback for traffic that doesn't use Tor. Using WireGuard is
pretty straightforward; `wg-quick` is the easiest way, though WireGuard
can be directly configured with
[`ifconfig(8)`](https://man.openbsd.org/ifconfig) as well.

Note that I only use IPv4 for the sake of simplicity. Additional steps
are needed if IPv6 tunneling is required.

### Method 1: `wg-quick`

Install `wireguard-tools`.

    # pkg_add wireguard-tools

Bring the [`wg(4)`](https://man.openbsd.org/wg) interface up using
`wg-quick` (omit the filename extension for conf filename).

    # wg-quick up [conf filename]

Modify the `nat-to` entry in
[`pf.conf(5)`](https://man.openbsd.org/man/pf.conf) accordingly. In my
case, `vport0` and `wg0` are the relevant interfaces.

    match out on wg0 inet from (vport0:network) nat-to (wg0)

Test the configuration.

    # pfctl -f /etc/pf.conf -nvv

If everything looks right, load [`pf.conf(5)`](https://man.openbsd.org/pf.conf).

    # pfctl -f /etc/pf.conf

Verify from a connected client.

    $ curl ifconfig.me -w '\n'

If everything's up and working, place this in `/etc/rc.local` so a
WireGuard connection is established on boot.

    /usr/local/bin/wg-quick up [conf filename]

This works just fine--that said, `ifconfig` has the advantage of no
dependencies.

### Method 2: `ifconfig`

Create `wg0`.

    # ifconfig wg0 create

Add the private key.

    # ifconfig wg0 wgkey [private key]

Add the public key and related options.

    # ifconfig wg0 wgpeer [public key] \
    > wgendpoint [endpoint addr] [port] \
    > wgaip 0.0.0.0/0

Add the IP address specified in the WireGuard configuration file.

    # ifconfig wg0 [if addr]

Set up the relevant routing table entries.

    # route -qn add -inet 0.0.0.0/1 -iface [if addr]
    # route -qn add -inet 128.0.0.0/1 -iface [if addr]
    # route -qn delete -inet [endpoint addr]
    # route -qn add -inet [endpoint addr] -gateway [gateway addr]

Modify the `nat-to` entry in
[`pf.conf(5)`](https://man.openbsd.org/man/pf.conf) accordingly. In my
case, `vport0` and `wg0` are the relevant interfaces.

    match out on wg0 inet from (vport0:network) nat-to (wg0)

Test the configuration.

    # pfctl -f /etc/pf.conf -nvv

If everything looks right, load [`pf.conf(5)`](https://man.openbsd.org/pf.conf).

    # pfctl -f /etc/pf.conf

Verify from a connected client.

    $ curl ifconfig.me -w '\n'

If everything's up and working, place this in
`/etc/hostname.wg0` so a WireGuard connection is established on boot.

    wgkey [private key]
    wgpeer [public key] \
      wgendpoint [endpoint addr] [port] \
      wgaip 0.0.0.0/0

    inet [if addr]

    !route -qn add -inet 0.0.0.0/1 -iface [if addr]
    !route -qn add -inet 128.0.0.0/1 -iface [if addr]
    !route -qn delete -inet [endpoint addr]
    !route -qn add -inet [endpoint addr] -gateway [gateway addr]

### Concerning WireGuard and Unbound

- Ensure `127.0.0.1` is used for DNS or the router won't use
[`unbound(8)`](https://man.openbsd.org/man8/unbound.8). See
[`resolv.conf(5)`](https://man.openbsd.org/resolv.conf).
- Set the IP address of the VPN's DNS server as the `forward-addr` in
[`unbound.conf(5)`](https://man.openbsd.org/unbound.conf).
- Don't set `forward-first: yes` or DNS leaks will occur whenever
the upstream resolver fails.
