# domain-sift: extract and format domains

Last updated: July 4th, 2025

`domain-sift` is a Perl script that extracts unique domains from at
least one provided file and prints them to standard output in a given
format. If you don't provide a file, `domain-sift` reads from standard
input (STDIN) instead.

One use of this utility: extract domains from blocklists that contain
known malicious or otherwise undesirable domains, then format them so
that a DNS (Domain Name System) resolver can block those domains.

## Table of contents

<!-- mtoc-start -->

- [Project structure](#project-structure)
- [Installation](#installation)
- [Documentation](#documentation)
- [domain-sift and unwind](#domain-sift-and-unwind)
- [domain-sift and Unbound](#domain-sift-and-unbound)
- [domain-sift and Unbound (RPZ)](#domain-sift-and-unbound-rpz)
- [About blocklist sources](#about-blocklist-sources)
- [Caveats](#caveats)
- [License](#license)

<!-- mtoc-end -->

## Project structure

    |-- Changes
    |-- LICENSE
    |-- MANIFEST
    |-- Makefile.PL
    |-- README.md
    |-- bin
    |   `-- domain-sift
    |-- lib
    |   `-- Domain
    |       |-- Sift
    |       |   |-- Manipulate.pm
    |       |   `-- Match.pm
    |       `-- Sift.pm
    `-- t
        |-- 00-load.t
        |-- Domain-Sift-Manipulate.t
        |-- Domain-Sift-Match.t
        |-- manifest.t
        |-- pod-coverage.t
        `-- pod.t

## Installation

To install `domain-sift`, [download the most recent
release](https://github.com/maybebyte/domain-sift/releases) and run the
following commands inside the source directory. Note that `domain-sift`
requires Perl 5.36 or later, since subroutine signatures are no longer
experimental in that release.

    $ perl Makefile.PL
    $ make
    $ make test
    # make install

## Documentation

After installation, you can read the documentation with `perldoc`. `man`
often works as well.

    $ perldoc Domain::Sift
    $ perldoc Domain::Sift::Match
    $ perldoc Domain::Sift::Manipulate
    $ perldoc domain-sift

## domain-sift and unwind

Here's how to use `domain-sift` with
[`unwind(8)`](https://man.openbsd.org/unwind) on OpenBSD.

1.  Get domains from your blocklist source:

```
$ domain-sift /path/to/blocklist_source > blocklist
```

2.  Move your blocklist to `/etc/blocklist`:

```
# mv blocklist /etc/blocklist
```

3.  Edit your `unwind.conf` to include your new blocklist:

```
block list "/etc/blocklist"
```

4.  Restart `unwind`:

```
# rcctl restart unwind
```

## domain-sift and Unbound

Here's how to use `domain-sift` with [`unbound(8)`](https://man.openbsd.org/unbound) on OpenBSD.

1.  Get domains from your blocklist source:

```
$ domain-sift -f unbound /path/to/blocklist_source > blocklist
```

2.  Move the blocklist to `/var/unbound/etc`.

```
# mv blocklist /var/unbound/etc/blocklist
```

3.  Edit your `unbound.conf` to include your new blocklist:

```yaml
include: "/var/unbound/etc/blocklist"
```

4.  Restart Unbound.

```
# rcctl restart unbound
```

## domain-sift and Unbound (RPZ)

`domain-sift` also supports the Response Policy Zone (RPZ) format. [This
Internet Draft defines the RPZ
format](https://datatracker.ietf.org/doc/draft-vixie-dnsop-dns-rpz/).

With RPZ, you can create DNS blocking policies in a standardized way.
You can even block wildcarded domains (`*.example.com` also blocks
`subdomain.example.com`, `subdomain.subdomain.example.com`, and so on).

Here's how to use `domain-sift` with Unbound and RPZ on OpenBSD.

1.  Get domains from your blocklist source:

```
$ domain-sift -f rpz /path/to/blocklist_source > blocklist
```

2.  Edit your `unbound.conf`:

```yaml
rpz:
  name: rpz.home.arpa
  zonefile: /var/unbound/etc/rpz-block.zone
  #rpz-log: yes
  rpz-signal-nxdomain-ra: yes
```

NOTE: `rpz.home.arpa` serves as an example. The name entry may be
different in your case. In a local area network (LAN) where Unbound
runs on the gateway/router, make sure that a `local-data` entry exists
somewhere so that the name you chose resolves. Something like this
should work:

```yaml
local-data: "rpz.home.arpa. IN A x.x.x.x"
```

You'll need to replace `x.x.x.x` with the machine's actual IP address.

3.  Create `/var/unbound/etc/rpz-block.zone`:

```DNS
$ORIGIN rpz.home.arpa.
$INCLUDE /var/unbound/etc/blocklist
```

4.  Make sure that you move `blocklist` to the correct location:

```
# mv /path/to/blocklist /var/unbound/etc/blocklist
```

5.  Restart Unbound:

```
# rcctl restart unbound
```

## About blocklist sources

`domain-sift` only deals with extracting domains from text files and
formatting them. It doesn't fetch blocklists or provide them.

The design explicitly includes this limitation for a few reasons:

1.  It follows the Unix philosophy: do one thing well; read from a file
    or STDIN; print to STDOUT.

2.  It lets `domain-sift` use minimal
    [`pledge(2)`](https://man.openbsd.org/pledge) promises through
    [`OpenBSD::Pledge(3p)`](https://man.openbsd.org/OpenBSD%3A%3APledge).

3.  The simple design makes it much more flexible and portable.

Here's roughly what I use to fetch blocklists:

```
$ grep -Ev '^#' blocklist_urls | xargs -- ftp -o - | domain-sift > blocklist
```

You can find blocklist sources in many places, such as
[firebog.net](https://firebog.net/).

## Caveats

If you've pulled in a lot of domains, Unbound may fail to start on
OpenBSD because it doesn't have enough time to process them all. You
can fix this by increasing Unbound's timeout value.

```
$ rcctl get unbound timeout
30
# rcctl set unbound timeout 120
$ rcctl get unbound timeout
120
```

## License

This software is Copyright © 2023 by Ashlen.

This software uses the ISC License (Internet Systems Consortium
License). For more details, see the `LICENSE` file in the project root.
