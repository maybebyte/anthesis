# Software I use

This page primarily exists for two reasons: a) for those interested in
my workflow b) to document things for myself.

Here are some resources that I find useful:

- [Arch wiki](https://wiki.archlinux.org/index.php/List_of_applications)
- [Privacytools.io](https://www.privacytools.io/)
- [Prism break](https://prism-break.org)
- [AlternativeTo](https://alternativeto.net/)
- ["Awesome" topic on github](https://github.com/topics/awesome)
- [Alternatives to bloatware](https://github.com/mayfrost/guides/blob/master/ALTERNATIVES.md)
- [OpenBSD's](https://www.openbsd.org) base system


**Operating Systems**

[OpenBSD](https://www.openbsd.org/) powers most of my hardware. My Pixel
3a runs [GrapheneOS](https://grapheneos.org/). I prefer to build from
the bottom up rather than stripping away unneeded software from a more
full-featured OS.

**Window Manager**

[i3](https://i3wm.org/). Note that I use
[sxhkd](https://github.com/baskerville/sxhkd) to bind keys.

**Bar**

i3status + i3bar. [Lemonbar](https://github.com/LemonBoy/bar) also seems
promising.

**Compositor**

[xcompmgr](https://man.openbsd.org/xcompmgr.1).

**Color Scheme Generator**

[Pywal](https://github.com/dylanaraps/pywal). Pywal grabs the dominant
colors from an image (usually a wallpaper) to use for theming.

**Fonts**

Serif: Linux Libertine.

Sans-serif: Linux Biolinum and Fira Sans.

Monospace: Cascadia Code and/or Inconsolata.

Bitmap: Terminus.

Emoji: Symbola.

**Terminal**

[St](https://st.suckless.org), specifically [Luke Smith's
build](https://github.com/LukeSmithxyz/st).

**Multiplexer**

[Tmux](https://github.com/tmux/tmux).

**Editor**

[Vim](https://www.vim.org). I positively adore vim. If you want to learn
it, `vimtutor` is your friend. I promise it's not as hard as people make
it out to be.

**File Manager**

[Ranger](https://github.com/ranger/ranger). It's a vim-inspired terminal
file
manager. [Ranger_devicons](https://github.com/alexanderjeurissen/ranger_devicons)
adds icons, though I don't use them.

**Browser**

[Tor Browser](https://www.torproject.org) and
[Firefox](https://www.mozilla.org/en-US/firefox/). Once configured, they
mitigate tracking more effectively than the other browsers I've tried.

I do have my gripes with Firefox (gigantic code base and uses
questionable defaults, like Google as a search engine).

I harden Firefox with [ghacks'
user.js](https://github.com/ghacksuserjs/ghacks-user.js).

**Firefox Addons**

I try my best not to pile on the addons. They are mostly for privacy
because [the modern web sucks](https://suckless.org/sucks/web/).

[Bloody
Vikings!](https://addons.mozilla.org/en-US/firefox/addon/bloody-vikings/):
disposable email addresses.

[ClearURLs](https://addons.mozilla.org/en-US/firefox/addon/clearurls/):
removes tracking elements from URLs.

[Decentraleyes](https://addons.mozilla.org/en-US/firefox/addon/decentraleyes/):
no more centralized CDNs.

[HTTPS
Everywhere](https://addons.mozilla.org/en-US/firefox/addon/https-everywhere/):
moar HTTPS, Swiper no swiping.

[Terms of Service; Didn't
Read](https://addons.mozilla.org/en-US/firefox/addon/terms-of-service-didnt-read/):
understand a site's privacy policy at a glance.

[Tridactyl](https://addons.mozilla.org/en-US/firefox/addon/tridactyl-vim):
vim bindings for Firefox.

[uBlock
Origin](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/):
wide-spectrum content blocker with CPU and memory efficiency as primary
features.

[uMatrix](https://addons.mozilla.org/en-US/firefox/addon/umatrix/):
forbid/allow different types of content. I disable both Javascript
+ cookies, then whitelist as needed.

**Video Player**

[Mpv.](https://github.com/mpv-player/mpv) I pair it with
[youtube-dl](https://ytdl-org.github.io/youtube-dl/index.html) to stream
videos.

**Music Player**

[MPD](https://github.com/MusicPlayerDaemon/MPD) with
[NCMPCPP](https://rybczak.net/ncmpcpp/).

**RSS Reader**

[Newsboat](https://github.com/newsboat/newsboat). I use RSS feeds to
track new content. It removes the need to create accounts in order to
stay up to date.

**PDF Viewer**

[Zathura](https://git.pwmt.org/pwmt/zathura).

**Image Viewer**

[Sxiv](https://github.com/muennich/sxiv).

**Screenshots**

[Maim](https://github.com/naelstrof/maim). It's possible to pipe the
output of maim to xclip to send an image without saving it to
disk. I use
[maimpick](https://github.com/LukeSmithxyz/voidrice/blob/master/.local/bin/maimpick).

**Screen Locker**

[Slock](https://tools.suckless.org/slock/).

**Notification Daemon**

[Dunst](https://github.com/dunst-project/dunst).

# Cool miscellaneous software

These are programs that don't need a separate category and therefore
don't belong in the last section. The items below aren't limited to what
I use.

- [FZF](https://github.com/junegunn/fzf): CLI fuzzy finder. You can
  [search shell
  history](https://wiki.archlinux.org/index.php/Fzf#Shells) with it.
- [NCDU](https://dev.yorhel.nl/ncdu): NCurses Disk Usage.
- [Rmlint](https://github.com/sahib/rmlint): remove duplicates and other
  lint from your filesystem.
- [Ripgrep](https://github.com/BurntSushi/ripgrep): blazing fast code
  search.
- [Beets](https://github.com/beetbox/beets): manages music libraries and
  tags them appropriately using MusicBrainz.
- [Sct](https://flak.tedunangst.com/post/sct-set-color-temperature):
  blue light reduction/gamma management in a minimal C program, what's
  not to love?
- [Rig](http://rig.sourceforge.net/): Random Identity Generator.
- [Speedtest-cli](https://github.com/sivel/speedtest-cli): test
  connection speed.
- [USBGuard](https://github.com/USBGuard/usbguard): say no to
  [poisontap](https://github.com/samyk/poisontap) and friends.
- [Wireguard](https://www.wireguard.com/): next generation VPN client
  and server.
- [Unclutter-xfixes](https://github.com/Airblader/unclutter-xfixes):
  hides cursor when mouse is left idle.
- [SmartDeblur](https://github.com/Y-Vladimir/SmartDeblur): why I no
  longer use blur to redact things.
- [Taskwarrior](https://github.com/GothenburgBitFactory/taskwarrior):
  CLI task management tool.
