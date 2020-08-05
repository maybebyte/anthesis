# Clues

As in, have you got a clue? These are quirks/interesting things I've
learned, thus gaining a clue I previously didn't have.

1. `%` gets converted to a newline in
  [crontab(5)](https://man.openbsd.org/crontab.5) and all data after the
  first `%` is sent to the command as standard input unless
  escaped. I encountered this while working on an entry to back up my
  server with [tar(1)](https://man.openbsd.org/tar) that subsequently
  places the backup in a directory named the current date in
  "YYYY-mm-dd" format (I used [date(1)](https://man.openbsd.org/date) to
  generate this).
2. [Signal](https://www.signal.org/) stores its data in a folder called
  `org.thoughtcrime.securesms` on Android and Android-based
  devices. Furthermore, `thoughtcrime.org` redirects to `moxie.org`,
  a website that belongs to [Moxie
  Marlinspike](https://en.wikipedia.org/wiki/Moxie_Marlinspike). He
  co-authored the [Signal
  Protocol](https://en.wikipedia.org/wiki/Signal_Protocol).
