# Things I self-host

Some resources as per usual:

- [Lucid index](https://lucidindex.com/)
- [Awesome self-hosted
  (github)](https://github.com/Kickball/awesome-selfhosted)
- [Libre projects](https://libreprojects.net/)
- [/r/selfhosted](https://old.reddit.com/r/selfhosted/)
- [OpenBSD's](https://www.openbsd.org) base system

### **DNS Sinkhole**

[Pi-hole](https://github.com/pi-hole/pi-hole) is one of the most popular
uses for a [Raspberry
Pi](https://en.wikipedia.org/wiki/Raspberry_Pi). It acts as a [DNS
sinkhole](https://en.wikipedia.org/wiki/DNS_sinkhole) for ads and
telemetry and works on devices you may not expect (smart TVs, to name
one).

### **Media Center**

I use [Sakaki's 64-bit Raspberry Pi Gentoo
build](https://github.com/sakaki-/gentoo-on-rpi-64bit) to run
[Kodi](https://kodi.tv), though it's common for me to SSH in and stream
media via mpv.

# Why self-host/use FLOSS?

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
developers and end users. You are the product when you run proprietary
software.

Migration can be difficult. That difficulty is intended, as DRM is meant
to lock you in. It doesn't help that proprietary software is used by
friends, work, and school, or even required by the last two. Despite
that, I highly encourage you to explore free alternatives to proprietary
software you use. The libre lifestyle doesn't have to be all or nothing;
you can switch things out as you feel comfortable, like Google Chrome
for Firefox, and you'll be better for it.

## VPS providers

I recommend
[Exoscale](https://portal.exoscale.com/register?r=JEUcJnv6AIMe) (full
disclosure, that's a referral link. See [Exoscale's mentor
program](https://community.exoscale.com/documentation/platform/mentor-program/)
for details). Exoscale is a Swiss cloud provider that complies with
[GDPR regulations](https://www.exoscale.com/compliance/) and values data
privacy/security.

[openbsd.amsterdam](https://openbsd.amsterdam/) also seems excellent if
you want to have [vmm(4)](https://man.openbsd.org/vmm.4) as the
virtualization backend instead of
[KVM](https://www.linux-kvm.org/page/Main_Page). They donate €10 per VM
and then €15 for every renewal to the [OpenBSD
Foundation](https://www.openbsdfoundation.org/).
