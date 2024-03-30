# domain-sift

`domain-sift` is a Perl script that extracts unique domains from
at least one provided file and prints them to standard output in a
given format. If no file is provided, `domain-sift` reads from
standard input instead.

One use of this utility is to extract domains from blocklists that
contain known malicious or otherwise undesirable domains, and then
format them in such a way that those domains can be blocked by a
DNS resolver.

## Table of Contents

1. [Project structure](#project-structure)
2. [Installation](#installation)
3. [Documentation](#documentation)
4. [domain-sift and unwind](#domain-sift-and-unwind)
5. [domain-sift and unbound](#domain-sift-and-unbound)
6. [domain-sift and unbound (RPZ)](#domain-sift-and-unbound-rpz)
7. [Regarding blocklist sources](#regarding-blocklist-sources)
8. [Caveats](#caveats)
9. [License](#license)

## Project structure

```
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
```

## Installation

To install `domain-sift`, [download the most recent
release](https://github.com/3uryd1ce/domain-sift/releases) and run
the following commands inside the source directory. Note that
`domain-sift` requires Perl 5.36 or later, since subroutine signatures
are no longer experimental in that release.

```
$ perl Makefile.PL
$ make
$ make test
# make install
```

## Documentation

After installation, you can read the documentation with `perldoc`.
`man` often works as well.

```
$ perldoc Domain::Sift
$ perldoc Domain::Sift::Match
$ perldoc Domain::Sift::Manipulate
$ perldoc domain-sift
```

## domain-sift and unwind

Here's how to use `domain-sift` with
[`unwind(8)`](https://man.openbsd.org/unwind) on OpenBSD.

1. Extract domains from your blocklist source:

```
$ domain-sift /path/to/blocklist_source > blocklist
```

2. Move your blocklist to `/etc/blocklist`:

```
# mv blocklist /etc/blocklist
```

3. Then, modify your `unwind.conf` to include your new blocklist:

```
block list "/etc/blocklist"
```

4. Restart `unwind`:

```
# rcctl restart unwind
```

## domain-sift and unbound

Here's how to use `domain-sift` with
[`unbound(8)`](https://man.openbsd.org/unbound) on OpenBSD.

1. Extract domains from your blocklist source:

```
$ domain-sift -f unbound /path/to/blocklist_source > blocklist
```

2. Move the blocklist to `/var/unbound/etc`.

```
# mv blocklist /var/unbound/etc/blocklist
```

3. Then, modify your `unbound.conf` to include your new blocklist:

```yaml
include: "/var/unbound/etc/blocklist"
```

4. Restart Unbound.

```
# rcctl restart unbound
```

## domain-sift and unbound (RPZ)

`domain-sift` also supports the Response Policy Zone (RPZ) format.
[RPZ is defined in this Internet
Draft](https://datatracker.ietf.org/doc/draft-vixie-dnsop-dns-rpz/).

By using RPZ, you can define DNS blocking policies in a standardized
way. A nice perk of using RPZ is the ability to block wildcarded
domains (`*.example.com` will also block `subdomain.example.com`,
`subdomain.subdomain.example.com`, and so on).

Here's how to use `domain-sift` with Unbound and RPZ on OpenBSD.

1. Extract domains from your blocklist source:

```
$ domain-sift -f rpz /path/to/blocklist_source > blocklist
```

2. Then, modify your `unbound.conf`:

```yaml
rpz:
  name: rpz.home.arpa
  zonefile: /var/unbound/etc/rpz-block.zone
  #rpz-log: yes
  rpz-signal-nxdomain-ra: yes
```

NOTE: `rpz.home.arpa` is just an example. The name entry may be
different in your case. In a local access network (LAN) where Unbound
runs on the gateway/router, ensure that a `local-data` entry is
present somewhere so that the name you chose resolves. Something
like this should work:

```yaml
local-data: "rpz.home.arpa. IN A x.x.x.x"
```

You'll need to replace `x.x.x.x` with the machine's actual IP
address.

3. Create `/var/unbound/etc/rpz-block.zone`:

```DNS Zone
$ORIGIN rpz.home.arpa.
$INCLUDE /var/unbound/etc/blocklist
```

4. Make sure that you move `blocklist` to the correct location:

```
# mv /path/to/blocklist /var/unbound/etc/blocklist
```

5. Restart Unbound:

```
# rcctl restart unbound
```

## Regarding blocklist sources

To keep things simple, `domain-sift` only deals with extracting
domains from text files and formatting them. It doesn't fetch
blocklists or provide them.

This is an explicit part of its design for a few reasons.

1. It follows the Unix philosophy: do one thing well; read
   from a file or STDIN; print to STDOUT.

2. It allows `domain-sift` to use a minimum set of
   [`pledge(2)`](https://man.openbsd.org/pledge) promises through
   [`OpenBSD::Pledge(3p)`](https://man.openbsd.org/OpenBSD%3A%3APledge).

3. The simple design makes it much more flexible and portable.

Here is more or less what I use to fetch blocklists:

```
$ grep -Ev '^#' blocklist_urls | xargs -- ftp -o - | domain-sift > blocklist
```

You can find blocklist sources in many places, such as
[firebog.net](https://firebog.net/).

## Caveats

If you've pulled in a lot of domains, Unbound may fail to start on
OpenBSD because it doesn't have enough time to process all of them.
You can fix this by increasing Unbound's timeout value.

```
$ rcctl get unbound timeout
30
# rcctl set unbound timeout 120
$ rcctl get unbound timeout
120
```

## License

This software is Copyright © 2023 by Ashlen.

This is free software, licensed under the ISC License. For more
details, see the `LICENSE` file in the project root.
