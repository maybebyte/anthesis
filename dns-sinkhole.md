# Creating a DNS sinkhole with Perl and unbound(8)

*Tested on OpenBSD 7.0 and OpenBSD 7.1-current*

## What is a DNS sinkhole?

A DNS sinkhole is a domain name server that doesn't perform domain name
resolution for certain domains (typically those that contain undesired
content, such as trackers, malware, and ads).

Ordinarily, a client asks for the IP address associated with a domain
and the configured DNS server will provide it. Here, the [canary domain
"use-application-dns.net"](https://support.mozilla.org/en-US/kb/canary-domain-use-application-dnsnet)
is used as an example.

	$ host use-application-dns.net
	use-application-dns.net has address 44.236.72.93
	use-application-dns.net has address 44.235.246.155
	use-application-dns.net has address 44.236.48.31

Hopefully it's clear that domains are a human readable way to represent
one or more IP addresses, and that DNS is one part of a larger system
for communications. On a website, for instance, it's really TCP/IP that
allows a client to access the resources on the web server, and DNS is
merely the road map that shows how to get there.

A DNS sinkhole, then, refuses to hand out answers for certain domains.
Since the client trying to connect doesn't know the IP address of the
server to connect to, the connection won't be made.[^1]

	$ host use-application-dns.net
	Host use-application-dns.net not found: 5(REFUSED)

## Why not just use an adblocker?

There's nothing wrong with using a browser extension to block ads,
provided it's open source and trustworthy (I recommend [uBlock
Origin](https://ublockorigin.com/)).

DNS sinkholes have some unique strengths that aren't possible with an
adblocker alone. Domain filtering can be applied to the entire network,
meaning individual configuration for every device isn't strictly
necessary. One benefit of this is that domains can be blocked on devices
that aren't very manipulable otherwise (think Internet of Things, smart
TVs, mobile devices, guest devices, and so forth).

## Where to get the domains to block?

There are many different sources. The [ticked
lists](https://v.firebog.net/hosts/lists.php?type=tick) from
[firebog.net](https://firebog.net/) are worth considering. This is how
ticked lists are described:

>Sites with preferrably no falsely blocked sites, for Pi-hole installs that will have minimal maintenance

[Pi-hole](https://pi-hole.net/) is a popular DNS sinkhole with a web
interface.

Searching for [hosts(5)](https://man.openbsd.org/hosts) files will also
do the trick.

## Processing domains with genblock

`genblock` is a tool I wrote in Perl to extract domains from a given
input. Previously a shell script handled this, but I realized that shell
wasn't ideal for this task and scrapped it in favor of something more
structured and maintainable. Here's how to use `genblock`.

### The basics

Pretend there's a file named `examplefile` in the current directory that
has these contents.

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

The simplest way to process it with `genblock` is like this.

	$ ./genblock examplefile
	amazon.com
	facebook.com
	google.com
	instagram.com
	microsoft.com
	www.apple.com

Notice several things:

- Uppercase gets converted to lowercase. DNS is case insensitive.
- Duplicate entries are removed.
- Bogus entries aren't included.
- Lines that start with a comment are completely ignored (otherwise
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

The help output can be accessed like so.

	$ ./genblock -h

## Configuring a DNS resolver to use the blocklist

Remember to check after setup that domain filtering is properly
working with something like [`host(1)`](https://man.openbsd.org/host)
or [`dig(1)`](https://man.openbsd.org/host).

### Unbound

Move the file somewhere that indicates it's a system
configuration file (so `/etc`, or alternatively `/var/unbound/etc` on
OpenBSD) and give it world readable permissions, but nothing else.

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
there (a different directory is fine, too. This is just what I use).

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

These portions are better left outside of `genblock`, for portability
and to reduce code complexity. That way, there's no need to worry about
all of the different init systems, DNS resolvers, methods of fetching,
websites to fetch from, and so forth.

## Source code

The source code for `genblock` can be found in my `sysadm` repo,
accessible [on this website](/src/sysadm/) or [on
GitHub](https://github.com/3uryd1ce/sysadm).

## Addendum I: enforcing DNS provider in pf.conf

Of course, none of this will prevent queries to a different server.

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

If the DNS sinkhole is running on a router, place this in
[`pf.conf(5)`](https://man.openbsd.org/pf.conf) to block queries to
an external DNS server.

	block return in log quick proto { tcp udp } to !($int_if) port { domain domain-s }

The correct value for `$int_if` may vary. It's `vport0` in my case,
which is the same interface that hands out DHCP leases. Either way, it's
important to do this because many devices come with a fallback DNS entry
that will make these efforts for naught.

## Addendum II: getting around it

It's still possible to circumvent these measures even with firewall
rules in place. Encrypting outgoing traffic to be later decrypted with
something like a VPN, SSH tunnel, or Tor will get the job done.

[^1]: Please note that theoretically there's nothing preventing the
  client from connecting to the IP address itself, if it's known or can
  be discovered some other way.
