<div>
<nav class="navbar">
<ul>
  <li><a href="/index.html">/home</a></li>
  <li><a href="/pages/about-me.html">About</a></li>
  <li><a href="/pages/software.html">Software</a></li>
  <li><a class="active" href="/pages/selfhosting.html">Hosting</a></li>
  <li><a href="/pages/projects.html">Projects</a></li>
  <li><a href="/pages/clues.html">Clues</a></li>
</ul>
</nav>
</div>

# Things I self-host

Some resources as per usual:

- [Lucid index](https://lucidindex.com/)
- [Awesome self-hosted
  (github)](https://github.com/Kickball/awesome-selfhosted)
- [Libre projects](https://libreprojects.net/)
- [/r/selfhosted](https://old.reddit.com/r/selfhosted/)
- [OpenBSD's](https://www.openbsd.org) base system

**DNS Sinkhole**

[Pi-hole](https://github.com/pi-hole/pi-hole) is one of the most popular
uses for a [Raspberry
Pi](https://en.wikipedia.org/wiki/Raspberry_Pi). It acts as a [<abbr
title="Domain Name System">DNS</abbr>
sinkhole](https://en.wikipedia.org/wiki/DNS_sinkhole) for ads and
telemetry and works on devices you may not expect (<abbr
title="Telescreens">smart TVs</abbr>, to name one).

**Entertainment Center**

[Retropie](https://retropie.org.uk/) is a fantastic project. I grew up
with many of the games it supports so it's a valuable addition in that
it caters to my nostalgia. ^^ The [Argon
ONE](https://www.argon40.com/catalog/product/view/id/52/s/argon-one-raspberry-pi-4-case/category/4/)
makes it feasible to overclock the thermally challenged [Raspberry Pi
4B](https://www.raspberrypi.org/products/raspberry-pi-4-model-b/).

For all devices running Linux with <a
href="https://en.wikipedia.org/wiki/MultiMediaCard"><abbr
title="MultiMediaCard">MMC</abbr></a> storage, I prefer to use
[F2FS](https://en.wikipedia.org/wiki/F2fs), otherwise known as the
Flash-Friendly File System.

# Why self-host/use <abbr title="Free/Libre and Open Source Software">FLOSS</abbr>?

People often don't understand why I choose to be my own provider when
the payoff is, to them, about the same.

Libre software has these benefits among others: a)
customizability/control b) privacy/security (hiding source code is
security by obscurity, a demonstrably ineffective practice) c)
a collaborative development process that emphasizes quality over profit
d) more likely to conform to the [UNIX
philosophy](https://en.wikipedia.org/wiki/UNIX_philosophy).

Contrast with [proprietary
software](https://www.gnu.org/proprietary/proprietary.en.html), where
you can lose everything tied to an account at a whim, where
surveillance, planned obsolescence, incompatibility, censorship, and
deception are the norm, where a power differential exists between
developers and end users. You're the product when you run proprietary
software.

Migration can be difficult. That difficulty is intended, as <abbr
title="Digital Rights Management">DRM</abbr> is meant
to lock you in. It doesn't help that proprietary software is used by
friends, work, and school, or even required by the last two. Despite
that, I highly encourage you to explore free alternatives to proprietary
software you use. The libre lifestyle doesn't have to be all or nothing;
switch things out as you feel comfortable, like Google Chrome
for Firefox, and you'll be better for it.

## <abbr title="Virtual Private Server">VPS</abbr> providers

I recommend
[Exoscale](https://portal.exoscale.com/register?r=JEUcJnv6AIMe) (full
disclosure, that's a referral link. See [Exoscale's mentor
program](https://community.exoscale.com/documentation/platform/mentor-program/)
for details). Exoscale is a Swiss cloud provider [that respects the
<abbr title="General Data Protection
Regulation">GDPR</abbr>](https://www.exoscale.com/compliance/) and
values data privacy/security.

[openbsd.amsterdam](https://openbsd.amsterdam/) also seems excellent if
you want to have [vmm(4)](https://man.openbsd.org/vmm.4) as the
virtualization backend instead of [<abbr title="Kernel-based Virtual
Machine">KVM</abbr>](https://www.linux-kvm.org/page/Main_Page). They
donate €10 per <abbr title="Virtual Machine">VM</abbr> and then €15 for
every renewal to the [OpenBSD
Foundation](https://www.openbsdfoundation.org/).

## Domains

[Njalla](https://njal.la/) is worthwhile. They also have a VPS service,
though they only provided Debian, Ubuntu, CentOS, and Alpine when I used
it.
