# Software I use (PC)

This page primarily exists for two reasons:

1. To inform those interested in my workflow.
1. To meaningfully document the software I use for my own reference.

Here are some resources that I find useful:

- [Arch wiki](https://wiki.archlinux.org/index.php/List_of_applications)
- [Privacytools.io](https://www.privacytools.io/)
- [Prism break](https://prism-break.org)
- [AlternativeTo](https://alternativeto.net/)
- ["Awesome" topic on github](https://github.com/topics/awesome)
- [Alternatives to bloatware](https://github.com/mayfrost/guides/blob/master/ALTERNATIVES.md)

[![A screenshot of my laptop. A black status bar displaying system
information decorates the top, with a terminal emulator displaying the
contents of uname(1) below it. The wallpaper features a cute girl jotting
something down in her notebook and looking outside to an urban
landscape, with a cat near the foot of her
bed.](/images/rice-laptop-thumb.png "The epitome of comfy. Time is
redacted since that would reveal my time zone and thus general
location.")](/images/rice-laptop.png)

## Fundamentals

**Operating system**

[OpenBSD](https://www.openbsd.org/) powers most of my hardware.

I also tried and enjoyed [NixOS](https://nixos.org/). There's so much
potential in a declarative, reproducible system. If I've piqued your
curiosity, read [my thoughts on NixOS](/nixos.html).

**Window manager**

[xmonad](https://xmonad.org/). Overall, I really like
the fundamental concepts and design of Haskell.

Note that I use [sxhkd](https://github.com/baskerville/sxhkd "Simple
X Hotkey Daemon") to bind keys.

## Development tools

**Code search**

[Ripgrep](https://github.com/BurntSushi/ripgrep).

**Terminal**

[xst](https://github.com/gnotclub/xst), a fork of
[st](https://st.suckless.org/).

**Terminal multiplexer**

[`tmux(1)`](https://man.openbsd.org/tmux).

**Task organizer**

[Taskwarrior](https://taskwarrior.org/) is powerful and changed my
workflow for the better. Disorganization is the enemy of progress.

**Text editor**

[Neovim](https://neovim.io). To take your text editing to the next
level, follow these steps:

1. Add the neovim package.

        # pkg_add neovim

1. Open Neovim.

        $ nvim

1. Open the tutorial.

        :Tutor

**Static site generator**

[ssg](https://rgz.ee/ssg.html). I wrote in regular HTML before
I discovered this POSIX shell script. It generates
[`sitemap.xml`](https://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.215.5690&rep=rep1&type=pdf)
automatically. Writing in markdown is definitely quicker.

**RSS feed generator**

[rssg](https://rgz.ee/rssg.html).

## Day to day tasks

**Program launcher**

[Dmenu](https://tools.suckless.org/dmenu/). Despite appearances, I use
it as a conventional launcher very rarely (most of the programs I launch
have key bindings associated with them already). Dmenu's strength in my eyes
is its ability to read from STDIN and present a relevant menu. Given
this functionality, it's an excellent tool for scripting.

**Mail client**

[Neomutt](https://neomutt.org/).
[`smtpd(8)`](https://man.openbsd.org/smtpd), the mail daemon in
OpenBSD's base system, makes the experience even better given a sensible
[`smtpd.conf(5)`](https://man.openbsd.org/smtpd.conf.5). The
unadulterated joy I feel while composing emails in Neovim makes me
wonder why I didn't do this sooner.

**RSS reader**

[Newsboat](https://newsboat.org/). I use RSS feeds to track new
content because it removes the need to create accounts in order to stay up to
date.

**Screenshots**

[Maim](https://github.com/naelstrof/maim "Make Image"). I use
[maimpick](/src/dotfiles/file/.local/bin/maimpick.html), which leverages
dmenu.

**Screen locker**

[Slock](https://tools.suckless.org/slock/).

**Image viewer**

[Sxiv](https://github.com/muennich/sxiv "Simple X Image Viewer").

**PDF viewer**

[Zathura](https://git.pwmt.org/pwmt/zathura).

**Web browsers**

[Tor Browser](https://www.torproject.org) and
[Firefox](https://www.mozilla.org/en-US/firefox/). Tor Browser is as
private as it gets, so I use it over Firefox whenever possible.

It's worth mentioning that both of these browsers have
[`pledge(2)`](https://man.openbsd.org/man2/pledge.2) and
[`unveil(2)`](https://man.openbsd.org/unveil.2) support in OpenBSD.

I harden Firefox with [arkenfox's
user.js](https://github.com/arkenfox/user.js).

**Firefox addons**

Here are the addons I use. They're mostly for privacy because [the
modern web sucks](https://suckless.org/sucks/web/). Check [arkenfox's
user.js wiki](https://github.com/arkenfox/user.js/wiki/4.1-Extensions)
for more.

- [Bloody
  Vikings!](https://addons.mozilla.org/en-US/firefox/addon/bloody-vikings/):
  disposable email addresses.
- [ClearURLs](https://addons.mozilla.org/en-US/firefox/addon/clearurls/):
  removes tracking elements from URLs.
- [Skip
  Redirect](https://addons.mozilla.org/en-US/firefox/addon/skip-redirect/):
  when intermediary URLs are present, attempts to extract the destination URL
  and go there directly.
- [Smart
  Referer](https://addons.mozilla.org/en-US/firefox/addon/smart-referer/):
  [HTTP Referers are a privacy
  risk](https://developer.mozilla.org/en-US/docs/Web/Security/Referer_header:_privacy_and_security_concerns).
- [Temporary
  Containers](https://addons.mozilla.org/en-US/firefox/addon/temporary-containers/):
  can be configured to automatically open every new tab in a separate
  container, which isolates data and confers privacy + security.
- [Terms of Service; Didn't
  Read](https://addons.mozilla.org/en-US/firefox/addon/terms-of-service-didnt-read/):
  understand a site's privacy policy at a glance.
- [Tridactyl](https://addons.mozilla.org/en-US/firefox/addon/tridactyl-vim):
  Vim bindings for Firefox.
- [uBlock
  Origin](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/):
  content filtering/adblock.

Ideally, your results on [Cover Your Tracks](https://coveryourtracks.eff.org/)
should look similar to mine:

[![My Cover Your Tracks results show I'm blocking both tracking ads and
invisible trackers, as well as protecting me from
fingerprinting.](/images/coveryourtracks-results.png)](/images/coveryourtracks-results.png)

Anyone willing to put in this much effort to harden Firefox should
commit to using Tor Browser for most things. I use Firefox for precious
few tasks these days given that even with these tweaks, Firefox can't
protect the user as effectively as Tor Browser can.

## Entertainment

**Music player**

[MPD](https://www.musicpd.org/ "Music Player Daemon")
with [NCMPCPP](https://rybczak.net/ncmpcpp/ "NCurses Music Player C++").

**Video player**

[Mpv](https://mpv.io/). I pair it with
[youtube-dl](https://ytdl-org.github.io/youtube-dl/index.html) to stream
videos.

## Eye Candy

**Fonts**

- Serif: Noto Serif.
- Sans-serif: Noto Sans.
- Monospace: Iosevka.
- Bitmap: Terminus.
- Emoji: Symbola.

**Color scheme generator**

[Pywal](https://github.com/dylanaraps/pywal). Pywal grabs the dominant
colors from an image (usually a wallpaper) to use for theming.

**Status bar**

[Lemonbar](https://github.com/LemonBoy/bar). My status bar is built by piping
[sysinfo](/src/dotfiles/file/.local/bin/sysinfo.html)
into [lbar](/src/dotfiles/file/.local/bin/lbar.html).

**Idle cursor obfuscation**

[Unclutter-xfixes](https://github.com/Airblader/unclutter-xfixes).

## Miscellaneous

These are tools that don't neatly fit into any of the previously
established categories.

**Blue light reduction**

[Sct](https://flak.tedunangst.com/post/sct-set-color-temperature). Getting
proper rest is important and an abundance of blue light has a negative
effect on sleep.

**Connection tester**

[Speedtest-cli](https://github.com/sivel/speedtest-cli).

**Music tagger**

[Beets](https://beets.io/). See my [article on tagging music with
beets](/beets.html).
