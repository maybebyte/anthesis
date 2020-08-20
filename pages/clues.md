<div>
<nav class="navbar">
<ul>
  <li><a href="/index.html">/home</a></li>
  <li><a href="/pages/about-me.html">About</a></li>
  <li><a href="/pages/software.html">Software</a></li>
  <li><a href="/pages/selfhosting.html">Hosting</a></li>
  <li><a href="/pages/projects.html">Projects</a></li>
  <li><a class="active" href="/pages/clues.html">Clues</a></li>
</ul>
</nav>
</div>

# Clues

As in, have you got a clue? These are quirks/interesting things I've
learned, thus gaining a clue I previously didn't have.

1. `%` gets converted to a newline in
  [`crontab(5)`](https://man.openbsd.org/crontab.5) and all data after the
  first `%` is sent to the command as standard input unless
  escaped. I encountered this while working on an entry to back up my
  server with [`tar(1)`](https://man.openbsd.org/tar) that
  places the backup in a directory named the current date in
  "YYYY-MM-DD" format (I used [`date(1)`](https://man.openbsd.org/date) to
  generate this).
2. [Signal](https://www.signal.org/) stores its data in a folder called
  `org.thoughtcrime.securesms` on Android and Android-based
  devices. Furthermore, `thoughtcrime.org` redirects to `moxie.org`,
  a website that belongs to [Moxie
  Marlinspike](https://en.wikipedia.org/wiki/Moxie_Marlinspike). He
  co-authored the [Signal
  Protocol](https://en.wikipedia.org/wiki/Signal_Protocol).
3. An [apophasis](https://en.wiktionary.org/wiki/apophasis)
   is an allusion to something by denying that it will be
   mentioned. "Not to mention" and "to say nothing of" are
   both apophases.
4. [`whois(1)`](https://man.openbsd.org/whois) can use the US Department
   of Defense database with `whois -d` to query subdomains of the .mil
   top-level domain (TLD). Apparently the United States is the only
   country with a TLD for its military (though after contemplating this,
   it's not incredibly surprising given that
   [ARPANET](https://www.darpa.mil/about-us/timeline/arpanet) was highly
   influential in the advent of the Internet).
