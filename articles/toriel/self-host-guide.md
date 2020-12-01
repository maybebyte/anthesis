# So you want to self-host

That's great! You're on your way to becoming more free and tech
literate. In addition, you'll develop a working understanding of various
subjects you may not have encountered otherwise.

As a forewarning, self-hosting usually necessitates the command line,
though it's not as bad as people think. For whatever reason, people get
intimidated by command line interfaces. Learning often consists of
stumbling in the right direction, especially when cultivating a new
skill, and there's no shame in that. Making mistakes is all part of the
process.

If essential commands like `cd` and `ls` aren't in your repertoire,
consider one of two options:

1. learn more by consulting man pages, e.g.
   [`help(1)`](https://man.openbsd.org/help), and the [OpenBSD
   FAQ](https://www.openbsd.org/faq/).
1. pursue different avenues to liberate your online life and regain
   privacy. Install a [FLOSS operating system](/articles/software/os.html) or
   use [FLOSS software](/articles/software/pc.html) to accomplish day-to-day tasks.

Note that this page is intended as an overview and isn't exhaustive.

## Find what you want to host

Some resources for pedagogical purposes:

- [Awesome self-hosted
  (github)](https://github.com/Kickball/awesome-selfhosted)
- [Libre projects](https://libreprojects.net/)
- [Pi-hole](https://github.com/pi-hole/pi-hole)

If you're not sure what to host, try building a website. By
creating your own website, you become an Internet landlord and can
freely express your thoughts instead of remaining under someone else's
thumb. From here on out, I'll use setting up a website as an example.

## Pick an operating system

[OpenBSD](https://www.openbsd.org/) gets my vote. Most everything you
need will be in the base system and it takes the pain out of
administration (speaking as someone who also has experience with various
flavors of Linux). Once you explore the wonder that is
[`httpd(8)`](https://man.openbsd.org/httpd) in tandem with
[`acme-client(1)`](https://man.openbsd.org/acme-client), you'll wonder
why you wanted to host your web server on anything else.

[Why OpenBSD rocks](https://why-openbsd.rocks/fact/).

## Choose a VPS provider

I recommend
[Exoscale](https://portal.exoscale.com/register?r=JEUcJnv6AIMe) (full
disclosure, that's a referral link. See [Exoscale's mentor
program](https://community.exoscale.com/documentation/platform/mentor-program/)
for details). Exoscale is a Swiss cloud provider that respects the GDPR
and values data privacy/security.

[openbsd.amsterdam](https://openbsd.amsterdam/) also seems excellent if
you want to have [`vmm(4)`](https://man.openbsd.org/vmm.4) as the
virtualization backend instead of KVM. They donate €10 per VM and then
€15 for every renewal to the [OpenBSD
Foundation](https://www.openbsdfoundation.org/).

Whatever you choose, note the IPv4 and IPv6 address of your VPS after
you pick and deploy an OS. You'll need it for A/AAAA records in the next
step.

## Pick a domain

[Njalla](https://njal.la/) is worthwhile. They also have a VPS service,
though they didn't provide OpenBSD when I used it. Choose something
short and memorable for a domain name, as no one wants to type in a mile
long URL, then purchase it.

Now you need to point your domain to your server's IP using an A record
for IPv4 and an AAAA record for IPv6. To do so, use your domain
registrar's web interface. Without these, no one can visit your website
unless they type in the IP address of the machine it's hosted on.

## Read documentation

OK, now you have the prerequisites in place. You have a domain and
a VPS, so it's time to figure out how to make those useful, e.g. log
in with [`ssh(1)`](https://man.openbsd.org/ssh), read
[`afterboot(1)`](https://man.openbsd.org/afterboot), and set up
[`httpd(8)`](https://man.openbsd.org/httpd).

Between the built-in documentation (man pages), the FAQ, and the mailing
lists, OpenBSD is replete with learning materials.

Some other resources:

- Check out [Roman Zolotarev's website](https://rgz.ee/). He documents
  how to set up a web server in OpenBSD.
- [Here's how to write in
  Markdown](https://www.markdownguide.org/basic-syntax/). Note that you
  need something that can parse Markdown to make it useful. I like
  [lowdown](https://kristaps.bsd.lv/lowdown) in tandem with
  [SSG](https://rgz.ee/ssg.html).
- [Mozilla's web documentation](https://developer.mozilla.org/en-US/) is
  a great reference.

# Stuff I self-host

**Router**

See my article on [building an OpenBSD router](/articles/toriel/openbsd-router.html).

**Entertainment Center**

1. [Retropie](https://retropie.org.uk/) is great for those interested in
   retro gaming. I grew up with many of the games it supports so it
   caters to my nostalgia. The experience gets even better with
   multi-pass shaders, a good case (the Argon ONE is what I use), and
   a good audio system.
1. [MPD](https://www.musicpd.org/), so I can play music on the speakers
   without toil.
1. [Kodi](https://kodi.tv/), for my boyfriend.

When I run Linux on a device that has MMC storage, I prefer F2FS
(otherwise known as the Flash-Friendly File System). For more
information, see [F2FS: A New
File System for Flash
Storage](https://www.cs.fsu.edu/~awang/courses/cop5611_s2020/f2fs2.pdf).