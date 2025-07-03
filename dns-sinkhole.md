# Creating a DNS sinkhole with Perl and unbound(8)

_Tested on OpenBSD 7.0 and OpenBSD 7.1-current_

**NOTE (2023-09-10):** I'm deprecating genblock, please use
[domain-sift](/domain-sift.html) instead. domain-sift has a proper test
suite and packaging, unlike genblock. This page and genblock remain
available for historical purposes, at least for now.

## Table of contents

<!-- mtoc-start -->

- [What is a DNS sinkhole?](#what-is-a-dns-sinkhole)
- [Why not just use an adblocker?](#why-not-just-use-an-adblocker)
- [Where to get the domains to block?](#where-to-get-the-domains-to-block)
- [Processing domains with genblock](#processing-domains-with-genblock)
  - [The basics](#the-basics)
  - [Making genblock more useful](#making-genblock-more-useful)
  - [Getting more help](#getting-more-help)
- [Configuring a DNS resolver to use the blocklist](#configuring-a-dns-resolver-to-use-the-blocklist)
  - [Unbound](#unbound)
  - [Unwind](#unwind)
- [Automation](#automation)
- [Source code](#source-code)
- [Addendum I: Enforcing DNS provider in pf.conf](#addendum-i-enforcing-dns-provider-in-pfconf)
- [Addendum II: Getting around it](#addendum-ii-getting-around-it)

<!-- mtoc-end -->

## What is a DNS sinkhole?

A Domain Name System (DNS) sinkhole is a domain name server that doesn't
perform domain name resolution for certain domains (typically those that
contain undesired content, such as trackers, malware, and ads).

Ordinarily, a client asks for the IP address associated with a domain
and the configured DNS server provides it. Here, the [canary domain
"use-application-dns.net"](https://support.mozilla.org/en-US/kb/canary-domain-use-application-dnsnet)
serves as an example.

    $ host use-application-dns.net
    use-application-dns.net has address 44.236.72.93
    use-application-dns.net has address 44.235.246.155
    use-application-dns.net has address 44.236.48.31

Domains provide a human-readable way to represent one or more IP
addresses, and DNS forms one part of a larger system for communications.
On a website, for instance, TCP/IP enables a client to access the
resources on the web server, and DNS merely provides the road map that
shows how to get there.

A DNS sinkhole refuses to provide answers for certain domains. Since the
client trying to connect doesn't know the IP address of the server to
connect to, it won't make the connection.[^1]

    $ host use-application-dns.net
    Host use-application-dns.net not found: 5(REFUSED)

## Why not just use an adblocker?

Nothing prevents you from using a browser extension to block ads,
provided it's open source and trustworthy (I recommend [uBlock
Origin](https://ublockorigin.com/)).

DNS sinkholes have unique strengths that an adblocker alone cannot
provide. You can apply domain filtering to the entire network, meaning
individual configuration for every device isn't necessary. You can block
domains on devices that aren't easily configurable otherwise (think
Internet of Things, smart TVs, mobile devices, guest devices, and so
forth).

## Where to get the domains to block?

Many different sources exist. The [ticked
lists](https://v.firebog.net/hosts/lists.php?type=tick) from
[firebog.net](https://firebog.net/) are worth considering. Here's how
ticked lists work:

> Sites with preferably no falsely blocked sites, for Pi-hole installs
> that require minimal maintenance

[Pi-hole](https://pi-hole.net/) is a popular DNS sinkhole with a web
interface.

Searching for [hosts(5)](https://man.openbsd.org/hosts) files also
works.

## Processing domains with genblock

`genblock` is a tool I wrote in Perl to extract domains from a given
input. Previously a shell script handled this, but I realized that shell
wasn't ideal for this task and scrapped it in favor of something more
structured and maintainable. Here's how to use `genblock`.

### The basics

Pretend a file named `examplefile` exists in the current directory with
these contents.

    $ cat examplefile
    # Look at how awesome this blocklist is. Isn't it cool?
    # It only uses 100% verified and real domains.
    # Don't worry, bing.com is still accessible.
    google.com
    microsoft.com
    3.1415926
    www.apple.com
    FACEBOOK.com
    foobar
    127.0.0.1 instagram.com
    127.0.0.1 amazon.com
    192.168.1.1
    GOOGLE.COM

The simplest way to process it with `genblock` looks like this.

    $ ./genblock examplefile
    amazon.com
    facebook.com
    google.com
    instagram.com
    microsoft.com
    www.apple.com

Notice several things:

- Uppercase converts to lowercase. DNS is case insensitive.
- Duplicate entries are removed.
- Bogus entries don't appear.
- Lines that start with a comment are ignored completely (otherwise
  `bing.com` would appear in the list).
- Lines are sorted (easier to [`diff(1)`](https://man.openbsd.org/diff)
  that way)

### Making genblock more useful

Here's a more realistic example that fetches a blocklist and processes
it with `genblock`, then writes the output to a file in a format
accepted by [unbound(8)](https://man.openbsd.org/unbound).

    $ ftp -o - https://adaway.org/hosts.txt |
    > ./genblock -t unbound > blocklist.txt
    $ cat blocklist.txt
    local-zone: "0ce3c-1fd43.api.pushwoosh.com" always_refuse
    local-zone: "100016075.collect.igodigital.com" always_refuse
    local-zone: "10148.engine.mobileapptracking.com" always_refuse
    local-zone: "10870841.collect.igodigital.com" always_refuse
    local-zone: "1170.api.swrve.com" always_refuse
    local-zone: "1170.content.swrve.com" always_refuse
    local-zone: "1188.api.swrve.com" always_refuse
    [many more lines like this]

Note that `always_nxdomain` isn't used here. Giving the impression that
these domains don't exist when we aren't checking for existence
complicates troubleshooting. A clear response back shows that the
blocking is part of a policy, and that the DNS isn't broken.

### Getting more help

Access the help output like this.

    $ ./genblock -h

## Configuring a DNS resolver to use the blocklist

Remember to check after setup that domain filtering works properly with
something like [`host(1)`](https://man.openbsd.org/host) or
[`dig(1)`](https://man.openbsd.org/host).

### Unbound

Move the file somewhere that indicates it's a system configuration file
(so `/etc`, or alternatively `/var/unbound/etc` on OpenBSD) and give it
world readable permissions, but nothing else.

    # mv blocklist.txt /etc/blocklist.txt
    # chmod 0444 /etc/blocklist.txt

For `unbound`, add this somewhere in
[unbound.conf(5)](https://man.openbsd.org/unbound.conf).

    include: /etc/blocklist.txt

Check the config for validity.

    # unbound-checkconf /var/unbound/etc/unbound.conf
    unbound-checkconf: no errors in /var/unbound/etc/unbound.conf

Restart the service, assuming it's enabled and already running.

    # rcctl restart unbound
    unbound(ok)
    unbound(ok)

### Unwind

[`unwind(8)`](https://man.openbsd.org/unwind) is a validating DNS
resolver that's part of the OpenBSD base system. It's meant for
workstations or laptops and only listens on `localhost`.

One domain per line is the format `unwind` accepts per
[`unwind.conf(5)`](https://man.openbsd.org/unwind.conf), so no need to
do anything special there. Move the file and modify permissions as
before.

    # mv blocklist.txt /etc/blocklist.txt
    # chmod 0444 /etc/blocklist.txt

To include the file in `unwind.conf`, add this (optionally, with `log`
at the end as shown here to log blocked queries).

    block list /etc/blocklist.txt log

Check the config for validity.

    # unwind -n
    configuration OK

Restart the service, assuming it's enabled and already running.

    # rcctl restart unwind
    unwind(ok)
    unwind(ok)

## Automation

Create `/etc/sysadm` and move `genblock` and a list of blocklist URLs
there (a different directory works fine, too. This is just what I use).

    # mkdir -m 700 /etc/sysadm
    # mv genblock /etc/sysadm/
    # mv blocklist_urls /etc/sysadm/

[`cron(8)`](https://man.openbsd.org/cron) can handle the automation. To
generate a new blocklist weekly for `unbound` and check for validity
before restarting DNS, add this to `/etc/weekly.local`.

    # For genblock. Does blocklist handling so the script doesn't have
    # to. Generates blocklist from content of URLs and reloads daemons.
    /bin/test -e /etc/blocklist.txt \
    	&& /bin/mv /etc/blocklist.txt /etc/blocklist.txt.bak

    /usr/bin/xargs -- /usr/bin/ftp -o - -- < /etc/sysadm/blocklist_urls \
    	| /etc/sysadm/genblock -t unbound > /etc/blocklist.txt

    # https://support.mozilla.org/en-US/kb/canary-domain-use-application-dnsnet
    echo 'local-zone: "use-application-dns.net" always_refuse' >> /etc/blocklist.txt

    if /usr/sbin/unbound-checkconf; then
    	/bin/chmod 0444 /etc/blocklist.txt
    	/usr/sbin/rcctl restart unbound
    else
    	/bin/mv /etc/blocklist.txt.bak /etc/blocklist.txt
    fi

I keep these portions outside of `genblock` for portability and to
reduce code complexity. That way, there's no need to worry about all the
different init systems, DNS resolvers, methods of fetching, websites to
fetch from, and so forth.

## Source code

You can find the source code for `genblock` in my `sysadm` repo,
accessible [on this website](/src/sysadm/) or [on
GitHub](https://github.com/maybebyte/sysadm).

## Addendum I: Enforcing DNS provider in pf.conf

None of this prevents queries to a different server.

    # host use-application-dns.net
    Host use-application-dns.net not found: 5(REFUSED)
    # host use-application-dns.net 1.1.1.1
    Using domain server:
    Name: 1.1.1.1
    Address: 1.1.1.1#53
    Aliases:

    use-application-dns.net has address 44.236.72.93
    use-application-dns.net has address 44.235.246.155
    use-application-dns.net has address 44.236.48.31

If the DNS sinkhole runs on a router, place this in
[`pf.conf(5)`](https://man.openbsd.org/pf.conf) to block queries to an
external DNS server.

    block return in log quick proto { tcp udp } to !($int_if) port { domain domain-s }

The correct value for `$int_if` may vary. It's `vport0` in my case,
which is the same interface that hands out Dynamic Host Configuration
Protocol (DHCP) leases. Either way, this step matters because many
devices come with a fallback DNS entry that renders these efforts
useless.

## Addendum II: Getting around it

You can still circumvent these measures even with firewall rules in
place. Encrypting outgoing traffic to be later decrypted with something
like a Virtual Private Network (VPN), SSH tunnel, or Tor accomplishes
this.

[^1]:
    Please note that theoretically nothing prevents the client from
    connecting to the IP address itself, if it's known or can be
    discovered some other way.
