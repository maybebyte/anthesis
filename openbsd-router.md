# Building an OpenBSD router using an APU4D4

*Tested on OpenBSD 6.8*

## Foreword

It's no secret that consumer routers have security problems (600 CVEs
between 1999 and January of 2017, and those were only the disclosed
vulnerabilities) as a result of poorly engineered software. The paper
["So You Think Your Router Is
Safe?"](https://repository.stcloudstate.edu/cgi/viewcontent.cgi?article=1067&context=msia_etds)
addresses this subject well.

For a while, I was running [DD-WRT](https://dd-wrt.com/) on a Netgear
R7000P as my router. Even though it's leagues better than the stock
firmware (not a very high bar to clear) and makes for a capable access
point (AP), it has some pain points as a router. Here are a few that come to
mind.

1. Upgrades necessitate a total reconfiguration of the router's
   settings. If upgrades are hard, no one will do them... and then the
   system is wide open.
1. No package manager.
1. No service manager.
1. No man pages.
1. OpenBSD's networking tools are better than what Linux has to offer in
   my experience.
1. DD-WRT must be configured through the web interface despite support
   for SSH. It uses a read-only filesystem for `/` (SquashFS).

Lastly, one complaint that doesn't concern routing: if DD-WRT acts as an
access point, clicking 'Apply settings' in the web interface
necessitates reassociation due to DD-WRT resetting its network
interfaces.

DD-WRT is powerful set-and-forget consumer firmware, don't get me
wrong--I'd still recommend it over proprietary firmware. That said,
I was constantly wishing that I could peel back the layers of
abstraction and manage routing in a more transparent fashion. As someone
who's been bitten by the OpenBSD bug (or pufferfish, same difference),
the solution that came to mind was to build my own router. So I did, and
what follows is how I did it.

Note that I still use the Netgear R7000P as a [bridged
AP](https://wiki.dd-wrt.com/wiki/index.php/Wireless_access_point). OpenBSD's
AP support is a work in progress and an order of magnitude slower than
a bridged AP in my case.

## Hardware

To purchase an APU4D4 or similar, visit [PC
Engines](https://pcengines.ch/). Their boards come with
[coreboot](https://www.coreboot.org/) preinstalled and so far it's been
a great experience.

[![APU4B4 board on a wooden surface (front side).](/images/apu4b4_1_thumb.jpg)](/images/apu4b4_1.jpg)

[![APU4B4 board on a wooden surface (back side).](/images/apu4b4_2_thumb.jpg)](/images/apu4b4_2.jpg)

Include a [USB to DB9F serial
adapter](https://www.pcengines.ch/usbcom1a.htm) in your purchase, as
it's needed for the installation.

[![USB to DB9F serial adapter on a wooden surface.](/images/usbcom1a_thumb.jpg "It's a pretty nice cable, all in all.")](/images/usbcom1a.jpg)

[Consult the manual for assembly
instructions](https://pcengines.ch/pdf/apu4.pdf).

## Download OpenBSD

Download, verify, and flash the amd64 image that includes the file sets
`(installXX.img)` to a USB drive. [OpenBSD's FAQ covers
this](https://www.openbsd.org/faq/faq4.html).

## Install OpenBSD

Connect to the serial port. I run OpenBSD on my laptop, so I use
[`cu(1)`](https://man.openbsd.org/cu) for serial connections.

    # cu -l cuaU0 -s 115200

This indicates the line to use `(-l)` and the baud rate `(-s)`. The APU4D4
requires a baud rate of `115200`.

Now that you're connected, use this [OpenBSD APU4D4 installation
guide](https://hofmeyr.de/OpenBSD%20on%20APU4/).

## After installation

Do the usual, e.g. read
[`afterboot(8)`](https://man.openbsd.org/afterboot), check your mail,
etc. After that, there's a couple of things you'll probably want to
implement.

- A [firewall, DHCP server, and DNS
  server](https://www.openbsd.org/faq/pf/example1.html).
- A [network bridge for ethernet
  interfaces](https://www.openbsd.org/faq/faq6.html#Bridge). Remember to
  pass traffic as needed on the interfaces included within the
  bridge.
- Depending on your provider, you may need a PPPoE connection. See
  [`pppoe(4)`](https://man.openbsd.org/pppoe).
- [IPv6](https://lipidity.com/openbsd/router/), depending on your use
  case and whether your ISP supports it.
- DNS sinkhole with [`unbound(8)`](https://man.openbsd.org/unbound), see
  [genblock](/src/sysadm/file/genblock.html).

As always, give official OpenBSD documentation preferential treatment
and cross-reference it when using unofficial documentation. Keep it
simple and if you don't understand something, don't change it.

## WireGuard

I like to use a VPN on my home network, as I don't trust my ISP and it's
a good fallback for traffic that doesn't use Tor. Using WireGuard is
pretty straightforward; `wg-quick` is the easiest way, though WireGuard
can be directly configured with
[`ifconfig(8)`](https://man.openbsd.org/ifconfig) as well.

Note that I only use IPv4 for the sake of simplicity. Additional steps
are needed if IPv6 tunneling is required.

### Method 1: `wg-quick`

1. Install `wireguard-tools`.

        # pkg_add wireguard-tools

1. Bring the [`wg(4)`](https://man.openbsd.org/wg) interface up using
   `wg-quick` (omit the filename extension for conf filename).

        # wg-quick up [conf filename]

1. Modify your `nat-to` entry in
   [`pf.conf(5)`](https://man.openbsd.org/man/pf.conf) accordingly.

        match out on wg inet from !(wg:network) to any nat-to (wg:0)

1. Test the configuration.

        # pfctl -f /etc/pf.conf -nvv

1. If everything looks right, load [`pf.conf(5)`](https://man.openbsd.org/pf.conf).

        # pfctl -f /etc/pf.conf

1. Verify from a connected client.

        $ curl ifconfig.me -w '\n'

1. If everything's up and working, place the following in
   `/etc/rc.local` so a WireGuard connection is established on boot.

        /usr/local/bin/wg-quick up [conf filename]

This works just fine--that said, `ifconfig` has the advantage of no
dependencies.

### Method 2: `ifconfig`

1. Create `wg0`.

        # ifconfig wg0 create

1. Add the private key.

        # ifconfig wg0 wgkey [private key]

1. Add the public key and related options.

        # ifconfig wg0 wgpeer [public key] \
        wgendpoint [endpoint addr] [port] \
        wgaip 0.0.0.0/0

1. Add the IP address specified in your WireGuard configuration file.

        # ifconfig wg0 [if addr]

1. Set up the relevant routing table entries.

        # route -qn add -inet 0.0.0.0/1 -iface [if addr]
        # route -qn add -inet 128.0.0.0/1 -iface [if addr]
        # route -qn delete -inet [endpoint addr]
        # route -qn add -inet [endpoint addr] -gateway [gateway addr]

1. Modify your `nat-to` entry in
   [`pf.conf(5)`](https://man.openbsd.org/man/pf.conf) accordingly.

        match out on wg inet from !(wg:network) to any nat-to (wg:0)

1. Test the configuration.

        # pfctl -f /etc/pf.conf -nvv

1. If everything looks right, load [`pf.conf(5)`](https://man.openbsd.org/pf.conf).

        # pfctl -f /etc/pf.conf

1. Verify from a connected client.

        $ curl ifconfig.me -w '\n'

1. If everything's up and working, place the following in
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

1. Ensure `127.0.0.1` is used for DNS or your router won't use
   [`unbound(8)`](https://man.openbsd.org/man8/unbound.8). See
   [`resolv.conf(5)`](https://man.openbsd.org/resolv.conf).
1. Set the IP address of your VPN's DNS server as the `forward-addr` in
   [`unbound.conf(5)`](https://man.openbsd.org/unbound.conf).

Don't set `forward-first: yes` or you'll experience DNS leaks whenever
the upstream resolver fails.
