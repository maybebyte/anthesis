# Local authoritative DNS on OpenBSD using dhcpd(8) and unbound(8)

_Tested on OpenBSD 7.0_

One meaningful addition to home networks is the ability to refer to
devices using domain names instead of IP addresses. Domain names are
more memorable and human readable. Local authoritative Domain Name
System (DNS) enables things like this to work:

    $ host peterepeat
    peterepeat.home.arpa has address 192.168.1.241

    $ ping -c 1 peterepeat
    PING peterepeat.home.arpa (192.168.1.241): 56 data bytes
    64 bytes from 192.168.1.241: icmp_seq=0 ttl=255 time=0.395 ms

    --- peterepeat.home.arpa ping statistics ---
    1 packets transmitted, 1 packets received, 0.0% packet loss
    round-trip min/avg/max/std-dev = 0.395/0.395/0.395/0.000 ms

This document makes some assumptions. Primarily, that there's [a router
running OpenBSD](/openbsd-router.html) that serves Dynamic Host
Configuration Protocol (DHCP) and DNS with
[`dhcpd(8)`](https://man.openbsd.org/dhcpd) and
[`unbound(8)`](https://man.openbsd.org/unbound). Local authoritative DNS
extends this setup.

## Table of contents

<!-- mtoc-start -->

- [RFC8375 (why we use home.arpa.)](#rfc8375-why-we-use-homearpa)
- [Configuring unbound(8)](#configuring-unbound8)
- [Configuring dhcpd(8)](#configuring-dhcpd8)
- [Testing DNS resolution](#testing-dns-resolution)
- [Querying hosts without a FQDN](#querying-hosts-without-a-fqdn)

<!-- mtoc-end -->

## RFC8375 (why we use home.arpa.)

Often people choose a domain name for their home network on a whim,
something like `localdomain` or `lan`. I used `lan` for a while. It
turns out there's a specific-use domain name explicitly reserved for
this purpose: `home.arpa.` ([Check out RFC8375 for more
information](https://datatracker.ietf.org/doc/html/rfc8375)).

Now that we've chosen a domain name, let's configure it.

## Configuring unbound(8)

Unbound functions primarily as a caching recursive resolver. But it can
also serve zones authoritatively,[^1] as shown by this commented out
section in the default configuration file.

    # Serve zones authoritatively from Unbound to resolver clients.
    # Not for external service.
    #
    #local-zone: "local." static
    #local-data: "mycomputer.local. IN A 192.0.2.51"
    #local-zone: "2.0.192.in-addr.arpa." static
    #local-data-ptr: "192.0.2.51 mycomputer.local"

I prefer to include a separate file in
[`unbound.conf(5)`](https://man.openbsd.org/unbound.conf) so that this
part of the configuration remains distinct. Edit
`/var/unbound/etc/unbound.conf` and place the desired filename in there
somewhere.

    include: /var/unbound/etc/unbound.conf.lan

After writing those changes, create the included file and add these
contents. Adjust things as needed. Unbound already includes RFC8375
support, so you only need to add `local-data` and `local-data-ptr`.

    # Define individual hosts here. Both an A record and a PTR
    # record are needed. Note that local-data-ptr reverses local-data.
    local-data: "peterepeat.home.arpa. IN A 192.168.1.241"
    local-data-ptr: 192.168.1.241 peterepeat.home.arpa"

Save the file. Check that the syntax is valid (unbound checks the syntax
of the included file, too).

    # unbound-checkconf
    unbound-checkconf: no errors in /var/unbound/etc/unbound.conf

## Configuring dhcpd(8)

A viable [dhcpd.conf(5)](https://man.openbsd.org/dhcpd.conf) needs
to declare a domain name and at least one host, along with mandatory
parameters. A working configuration looks like this (note that
`fixed-address` takes a domain name, not an IP address).

    subnet 192.168.1.0 netmask 255.255.255.0 {
    	option domain-name "home.arpa";
    	option domain-name-servers 192.168.1.1;
    	option routers 192.168.1.1;
    	range 192.168.1.10 192.168.1.200;

    	host peterepeat {
    		fixed-address peterepeat.home.arpa;
    		hardware ethernet 34:cb:02:02:2c:0a;
    		option host-name "peterepeat";
    	}
    }

I prefer to add `use-host-decl-names` to assign the hostname
automatically based on the host declaration like so.

    subnet 192.168.1.0 netmask 255.255.255.0 {
    	option domain-name "home.arpa";
    	option domain-name-servers 192.168.1.1;
    	option routers 192.168.1.1;
    	range 192.168.1.10 192.168.1.200;

    	group {
    		use-host-decl-names on;

    		host peterepeat {
    			fixed-address peterepeat.home.arpa;
    			hardware ethernet 34:cb:02:02:2c:0a;
    		}
    	}
    }

Check that dhcpd accepts the configuration. If there are no
complaints, restart both daemons.

    # dhcpd -n
    # rcctl restart dhcpd unbound

## Testing DNS resolution

Get a new DHCP lease on the client side (as of OpenBSD 6.9, you can
do this with [dhcpleasectl(8)](https://man.openbsd.org/dhcpleasectl.8).
The correct interface varies).

    # dhcpleasectl re0

Then, try to resolve the new hostname.

    $ host peterepeat.home.arpa
    peterepeat.home.arpa has address 192.168.1.241
    $ host 192.168.1.241
    241.1.168.192.in-addr.arpa domain name pointer peterepeat.home.arpa.

## Querying hosts without a FQDN

This setup works well enough as-is, but you might not be able to query
hosts without a Fully-Qualified Domain Name (FQDN) out of the box. Check
to see if [`host(1)`](https://man.openbsd.org/host) fails with a partial
hostname.

    $ host peterepeat
    Host peterepeat not found: 3(NXDOMAIN)

This happens because the system doesn't append `.home.arpa` to
`peterepeat` before the lookup. The machine trying to perform the lookup
needs to have this line added to
[`resolv.conf(5)`](https://man.openbsd.org/resolv.conf).

    domain home.arpa

Now things work as expected, saving a few keystrokes.

    $ host peterepeat
    peterepeat.home.arpa has address 192.168.1.241

[^1]:
    [`nsd(8)`](https://man.openbsd.org/nsd) can also fulfill this
    function if you forward lookups to `home.arpa.` to it with unbound, but
    that's a more involved setup. RFC8375 states that combining the
    recursive resolver function for general DNS lookups with an
    authoritative resolver for `home.arpa.` is permissible.
