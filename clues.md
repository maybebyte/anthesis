# Get a clue

These are quirks/interesting things I've learned, thus gaining a clue
I previously didn't have. Usually these are things that don't warrant
a separate article, so I put them here instead. In addition, it's nice
to have a place to share miscellaneous thoughts.

1. `%` gets converted to a newline in
   [`crontab(5)`](https://man.openbsd.org/crontab.5) and all data after
   the first `%` is sent to the command as standard input unless
   escaped. I encountered this while working on an entry to back up my
   server with [`tar(1)`](https://man.openbsd.org/tar) that places the
   backup in a directory named the current date in "YYYY-MM-DD" format
   (I used [`date(1)`](https://man.openbsd.org/date) to generate this).

1. [Signal](https://www.signal.org/) stores its data in a folder called
   `org.thoughtcrime.securesms` on Android and Android-based
   devices. Furthermore, `thoughtcrime.org` redirects to `moxie.org`,
   a website that belongs to Moxie Marlinspike. He co-authored the
   Signal Protocol.

1. An apophasis is an allusion to something by denying that it will be
   mentioned. "Not to mention" and "to say nothing of" are both
   apophases.

1. [`whois(1)`](https://man.openbsd.org/whois) can use the US Department
   of Defense database with `whois -d` to query subdomains of the .mil
   top-level domain (TLD). Apparently the United States is the only
   country with a dedicated TLD for its military (though after
   contemplating this, it's not incredibly surprising given that ARPANET
   was highly influential in the advent of the Internet).

1. A shibboleth is any custom or tradition, usually a choice of phrasing
   or even a single word, that distinguishes one group of people from
   another. In a certain light, shibboleths are somewhat like passwords
   in that both are a proof of identity and a means to keep 'intruders'
   out.

1. The months July and August are named after Julius Caesar and
   Augustus, respectively.

1. The
   [frame-ancestors](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/frame-ancestors)
   directive in the
   [Content-Security-Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy)
   HTTP header obsoletes `X-Frame-Options: deny`.

1. As a follow-up to the last clue, the
   [Forwarded](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Forwarded)
   header is a more standardized version of the
   X-Forwarded-{For,Host,Proto} headers.

1. It's important to expose yourself to new things. When someone else is
   passionate about something, ask and genuinely listen to them, even if
   you're not interested in it. By listening, you expand your horizons,
   which allows you to draw connections between subjects, relate more to
   people, and pick up new hobbies.

1. Octopuses is the correct plural form of octopus, not octopi. Octopi
   is a hypercorrect word (meaning it's a misguided application of
   prescriptive grammar).

1. In xmonad (and I suspect other window managers), adding borders to
   browser windows causes them to do very poorly in fingerprinting
   tests. Borders can deanonymize Tor Browser users.

1. Use your search engine's capabilities to your advantage. For
   instance, to only return web pages that have either the `.edu` or
   `.gov` TLD (useful for research), use the `site` operator like so:
   `site:(edu | gov)`. See [Step-by-Step Guide & Research Rescue:
   Evaluating
   Credibility](https://guides.lib.byu.edu/c.php?g=216340&p=1428399) and
   [Google Hacking
   101](https://www.oakton.edu/user/2/rjtaylor/CIS101/Google%20Hacking%20101.pdf)
   (but don't use Google--many operators apply on other search engines,
   like DuckDuckGo or Searx).

1. Vim/Neovim can rotate characters 13 places using `g?{motion}` or
   `{Visual}g?`. On OpenBSD, [`rot13(6)`](https://man.openbsd.org/rot13)
   reads from standard input and performs the same conversion. [Here's
   an explanation of rot13](https://kb.iu.edu/d/aeol) in case you're
   wondering why anyone would ever need this.

1. `command -v` seems more portable than `which` and should be given
   preferential treatment most of the time. See [this Stack Exchange
   post](https://unix.stackexchange.com/questions/85249/why-not-use-which-what-to-use-then)
   for more details.

1. For the time being, HTTP keep-alive must be disabled in
   [`relayd(8)`](https://man.openbsd.org/relayd) in order for HTTP
   headers to be applied on subsequent requests. See [this marc.info
   thread](https://marc.info/?l=openbsd-misc&m=150287292709311&w=2) for
   more details.

1. In Super Mario World, there are exactly two ghost houses without a
   secret exit (Vanilla Ghost House and Choco-Ghost House). I spent too
   long trying to figure out where the second exit was because a mental
   heuristic that served me well most of the time didn't apply to those
   two. I suppose the lesson embedded in this experience is to avoid
   blindly trusting rules of thumb.

1. Regarding `line-height` in CSS, a minimum value of `1.5` is
   appropriate. This improves readability and accessibility.

1. [`sh(1)`](https://man.openbsd.org/sh) and
   [`ksh(1)`](https://man.openbsd.org/ksh) have some useful options.
   `-x` writes a trace of each command executed to standard
   error--great for debugging shell scripts. Whereas `-nv` can let
   you see how much of the shell script has been read.
