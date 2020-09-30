# So you want to self-host

That's great! You're on your way to becoming more free and tech
literate. In addition, you'll develop a working understanding of various
subjects you may not have encountered otherwise.

As a forewarning, self-hosting usually necessitates the command line,
though it's not as bad as people think. For whatever reason, people get
intimidated when they're at a shell prompt when it's a skill to be
developed like anything else. Learning often consists of stumbling in
the right direction, especially when first cultivating a skill, and
there's no shame in that. Making mistakes is all part of the process.

If essential shell commands like `ls` and `cd` aren't in your
repertoire, consider either a) learning more by consulting
[`help(1)`](https://man.openbsd.org/help) and the [OpenBSD
FAQ](https://www.openbsd.org/faq/) or b) pursuing different avenues to
liberate your online life and regain privacy, such as installing
a [FLOSS operating system](/os.html) or using FLOSS software to
accomplish day-to-day tasks.

Note that this page is meant to be an overview and not an
exhaustive list of what's involved in self-hosting.

## Find what you want to host

Some resources for pedagogical purposes:

- [Awesome self-hosted
  (github)](https://github.com/Kickball/awesome-selfhosted)
- [Libre projects](https://libreprojects.net/)

[The software I use](/software.html) may be relevant to you as well,
though it mostly applies to a personal computer instead of a server.

If you're still not sure what to host, try building a website. By
creating your own website, you become an Internet landlord and can
freely express your thoughts instead of remaining under someone else's
thumb. The rest of the guide uses setting up a website as an example.

## Pick an operating system

[OpenBSD](https://www.openbsd.org/) gets my vote. Most everything you
need will be in the base system and it takes the pain out of
administration (speaking as someone who has experience with various
flavors of Linux and OpenBSD). Once you explore the wonder that is
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
long URL, and then purchase it.

Now you need to point your domain to your server's IP using an A record
for IPv4 and an AAAA record for IPv6. Each domain registrar handles this
differently. Without these, no one will be able to visit your website
unless they type in the IP address of the machine it's hosted on.

## Read documentation

OK, now you have the prerequisites in place. You have a domain and
a VPS, so it's time to figure out how to make those useful, e.g. logging
in with [`ssh(1)`](https://man.openbsd.org/ssh), reading
[`afterboot(1)`](https://man.openbsd.org/afterboot) and setting up
[`httpd(8)`](https://man.openbsd.org/httpd). Between the built-in
documentation (man pages), the FAQ, and the mailing lists, OpenBSD is
replete with learning materials, so I'd be doing a disservice to both of
us if I duplicated all of it here.

Some other resources:

- Check out [Roman Zolotarev's website](https://rgz.ee/), he documents
  how to set up a web server in OpenBSD.
- [Here's how to write in
  Markdown](https://www.markdownguide.org/basic-syntax/). You'll need
  a static site generator to make it useful. I like
  [lowdown](https://kristaps.bsd.lv/lowdown) in tandem with
  [SSG](https://rgz.ee/ssg.html).
- [Mozilla's web documentation](https://developer.mozilla.org/en-US/) is
  superb.
