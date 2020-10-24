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
mind:

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

[![APU4B4, front side.](/images/apu4b4_1_thumb.jpg)](/images/apu4b4_1.jpg)

[![APU4B4, back side.](/images/apu4b4_2_thumb.jpg)](/images/apu4b4_2.jpg)

Include a [USB to DB9F serial
adapter](https://www.pcengines.ch/usbcom1a.htm) in your purchase, as
it's needed for the installation.

[![USB to DB9F serial adapter.](/images/usbcom1a_thumb.jpg)](/images/usbcom1a.jpg)

[Consult the manual for assembly
instructions](https://pcengines.ch/pdf/apu4.pdf).

## Download OpenBSD

Download, verify, and flash the amd64 image that includes the file sets
`(installXX.img)` to a USB drive. [OpenBSD's FAQ covers
this](https://www.openbsd.org/faq/faq4.html).

## Install OpenBSD

Connect to the serial port. I run OpenBSD on my laptop, so I use
[`cu(1)`](https://man.openbsd.org/cu) for serial connections.

`# cu -l cuaU0 -s 115200`

This indicates the line to use `(-l)` and the baud rate `(-s)`. The APU4D4
requires a baud rate of 115200.

Now that you're connected, use this [OpenBSD APU4D4 installation
guide](https://www.tumfatig.net/20200530/openbsd-6-7-on-pc-engines-apu4d4/).

## After installation

Do the usual, e.g. read
[`afterboot(8)`](https://man.openbsd.org/afterboot), check your mail,
etc. After that, there's a couple of things you'll probably want to
implement:

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

As always, give official OpenBSD documentation preferential treatment
and cross-reference it when using unofficial documentation. Keep it
simple and if you don't understand something, don't change it.

## WireGuard

I like to use a VPN on my home network, as I don't trust my ISP and it's
a good fallback for traffic that doesn't use Tor. Using WireGuard is
pretty straightforward, as the 6.8 release added
[`wg(4)`](https://man.openbsd.org/wg).

Note that I only use IPv4 for the sake of simplicity; additional steps
are needed if IPv6 tunneling is required.

Install WireGuard:

`# pkg_add wireguard-tools`

Bring the [`wg(4)`](https://man.openbsd.org/wg) interface up using
`wg-quick` (omit the filename extension for conf filename):

`# wg-quick up [conf filename]`

Modify your `nat-to` entry in
[`pf(4)`](https://man.openbsd.org/man4/pf.4) accordingly:

`match out on wg inet from !(wg:network) to any nat-to (wg:0)`

Test the configuration:

`# pfctl -f /etc/pf.conf -n -vv`

If everything looks right, load [`pf.conf(5)`](https://man.openbsd.org/pf.conf):

`# pfctl -f /etc/pf.conf`

Verify from a connected client:

`$ curl ifconfig.me && printf '\n'`

If everything's up and working, place the following in `/etc/rc.local`:

`/usr/local/bin/wg-quick up [conf filename]`

### Concerning WireGuard and Unbound

If you run [`unbound(8)`](https://man.openbsd.org/unbound), replace the
DNS entry in the WireGuard configuration file with `127.0.0.1` or your
router won't use it. After doing so, set the IP address of your VPN's
DNS server as the `forward-addr` in
[`unbound.conf(5)`](https://man.openbsd.org/unbound.conf).
