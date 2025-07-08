# Recommended F-Droid apps

**NOTE:** Though I care about open source software, I can no longer
recommend F-Droid as an app store as of 2023-04-18. Please see [F-Droid
Security
Issues](https://privsec.dev/posts/android/f-droid-security-issues/).
These days I prefer to [update apps via Really Simple Syndication
(RSS)](https://www.privacyguides.org/en/android/#manually-with-rss-notifications)
instead.

I may rewrite this post or delete it later, but I felt I should at least
mention this concern first.

## Table of contents

<!-- mtoc-start -->

- [What is F-Droid?](#what-is-f-droid)
- [F-Droid apps](#f-droid-apps)

<!-- mtoc-end -->

## What is F-Droid?

From the [F-Droid website](https://www.f-droid.org/):

> "F-Droid is an installable catalogue of FOSS (Free and Open Source
> Software) applications for the Android platform. The client makes it
> easy to browse, install, and keep track of updates on your device."

## F-Droid apps

- [ImagePipe](https://f-droid.org/en/packages/de.kaffeemitkoffein.imagepipe/)
  or [Scrambled
  Exif](https://f-droid.org/en/packages/com.jarsilio.android.scrambledeggsif/).
  Both apps remove Exchangeable Image File Format (EXIF) data, metadata in
  photos that can reveal personal information, before you send pictures.
  Despite serving a similar purpose, the two apps differ in implementation
  and features. Notably, ImagePipe also reduces image size (though it
  keeps the original unaltered and stores the changed copy in a separate
  folder), which may or may not be desirable depending on your use case.
- [Keep It Simple, Stupid (KISS)
  Launcher](https://f-droid.org/en/packages/fr.neamar.kiss/). I find that
  pinning a few choice apps and searching for the rest with KISS Launcher
  provides a more pleasant experience relative to the default
  [GrapheneOS](https://grapheneos.org/) launcher. Also, launchers let you
  use custom icons (I use [Arcticons
  Dark](https://f-droid.org/en/packages/com.donnnno.arcticons/)).
- [Meditation
  Assistant](https://f-droid.org/en/packages/sh.ftp.rocketninelabs.meditationassistant.opensource/).
  Practice agnostic and doesn't do more than I need it to--in other words,
  perfect for my use case.
- [mpv-android](https://f-droid.org/en/packages/is.xyz.mpv/). For those
  that love [mpv](https://mpv.io/) and want it on their phone, too.
- [Netguard](https://netguard.me/). Block internet access per app.
  Unfortunately, I haven't found a way to combine it with Orbot yet.
- [NewPipe](https://newpipe.net/). NewPipe lets you watch YouTube
  privately on your phone; you can also keep up with your favorite content
  creators without signing up for an account.
- [Orbot](https://guardianproject.info/apps/org.torproject.android/). An
  invaluable tool for privacy, Orbot tunnels the traffic of selected apps
  through Tor.
- [RedReader](https://f-droid.org/packages/org.quantumbadger.redreader/),
  an unofficial open source client for Reddit. It has a clean UI with no
  nonsense. I found it through word of mouth, as I've never liked the
  redesign and wanted to find a less feature-rich (and less buggy) client
  than Slide. This is exactly what RedReader delivers.
- [Termux](https://termux.com/). Termux provides a terminal emulator for
  Android and offers an incredible amount of power. I use Termux to
  securely transfer files between my phone and computer using SSH.
- [Yet Another Call Blocker
  (YACB)](https://f-droid.org/en/packages/dummydomain.yetanothercallblocker/).
  A useful app. You can add problematic area codes to YACB and it filters
  them out automatically. You can exempt contacts from being treated as
  unknown callers, and YACB even has an option to stop the call before the
  phone starts ringing on Android 7+.
- [UntrackMe](https://f-droid.org/en/packages/app.fedilab.nitterizeme/).
  UntrackMe transforms certain links, such as YouTube, Twitter, and
  Instagram, to point at a Free/Libre and Open Source Software (FLOSS)
  privacy respecting alternative. In the case of Twitter, it changes the
  domain to a Nitter instance.
