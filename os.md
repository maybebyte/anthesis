# FLOSS OS recommendations

## Generate recommendations from a quiz

Check out [LibreHunt](https://librehunt.org/) if you want something more
hands-on. LibreHunt does a good job of explaining the merits of FLOSS
and suggests Linux distributions based on how you answer its
questionnaire.

## My recommendations

First assess what you want and need in an OS. Do you want to maintain
a similar workflow or do you want to learn a more minimal way of doing
things?

### Maintaining a similar workflow

[![Screenshot of Linux Mint 20 "Ulyana" Cinnamon
Edition.](/images/cinnamon-thumb.png "Look at all those buttons. You can probably click them or something.")](/images/cinnamon-full.png)

Try [Linux Mint](https://www.linuxmint.com/download.php), specifically
the Cinnamon Edition. I believe in this OS enough that a USB flash drive
with Linux Mint is always on my person in case someone wants me to set
it up for them (perhaps I should have a utility belt with USB drives
strapped to it; each drive would be flashed with a different OS).

Linux Mint provides a familiar interface and full-featured applications
so the user can hit the ground running. The developers dedicate a lot of
time to make the system intuitive without a sacrifice in customizability
and I really appreciate that approach.

### Trying something more minimal

[![The OpenBSD logo with the mascot, Puffy the pufferfish, above it.](/images/openbsd-logo.png "Puffy is one of my favorite mascots.")](/images/openbsd-logo.png)

Take a look at [OpenBSD](https://www.openbsd.org/). It follows the KISS
philosophy, yet the system is robust enough to handle many different use
cases (building a web server or a router is feasible using only the
tools available in the base system).

OpenBSD feels transparent and comprehensible due to great documentation
and minimal tools that work together. These things along with
a proactive attitude toward security makes OpenBSD comfy, in a word.

That said, make no mistake: even though it comes with good defaults,
OpenBSD requires a bit of reading. While full-featured desktop environments
like GNOME are available, the system itself doesn't graphically abstract
away tasks in the name of user-friendliness. Believe it or not, this is
actually a blessing in disguise--if you learn how the system works as
you go, that incremental understanding allows you to do new things and
fix problems should they arise.

If you do install it, remember to consult the FAQ. It's particularly
useful to newcomers as it shows you how to perform common tasks.

## Other devices you can liberate

### Smartphone

Use a privacy respecting OS for your mobile device if you can.
[GrapheneOS](https://grapheneos.org/) is what I use, although
[LineageOS](https://www.lineageos.org/) supports a wider range of
hardware.

### Router

Your router is a computer too. Proprietary consumer firmware isn't very
capable, nor is it secure. DD-WRT, OpenWRT, pfSense, and OpenBSD are all
much better options. If you decide to flash firmware onto a consumer
router, use Ethernet and take the appropriate precautions.

Check out [Building an OpenBSD router](/openbsd-router.html) for more
information on how I approach it.
