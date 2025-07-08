# Tagging and managing music with beets

Last updated: July 8th, 2025

## Table of contents

<!-- mtoc-start -->

- [Why metadata matters](#why-metadata-matters)
- [Beets as a music manager](#beets-as-a-music-manager)
- [How to install beets](#how-to-install-beets)
- [How to configure beets](#how-to-configure-beets)
- [How to import music](#how-to-import-music)
- [How to query music](#how-to-query-music)
- [What plugins does beets have?](#what-plugins-does-beets-have)
  - [Album art with fetchart](#album-art-with-fetchart)
  - [Genre metadata with lastgenre](#genre-metadata-with-lastgenre)
- [Cue sheets and how to use them](#cue-sheets-and-how-to-use-them)
  - [Scripting cue splitting](#scripting-cue-splitting)

<!-- mtoc-end -->

## Why metadata matters

Tagged music files come with significant benefits. To name just a few:

- You know what to expect from your music without relying on long
  filenames or navigating through a forest of directories.

- You can find music of a specific type by querying the metadata. For
  instance, you can list all music from a specific genre or year.

- ReplayGain normalizes loudness so that your hand can rest somewhere
  other than the volume knob.

## Beets as a music manager

If you've never tagged music before or want to change your workflow,
maybe you can [use beets to manage your library](https://beets.io/). You
can gain many of the benefits mentioned before through fetching and
applying metadata from sources like
[MusicBrainz](https://musicbrainz.org/). Plugins fill in the gaps.

You may like to keep [the documentation for
beets](https://beets.readthedocs.io) in a separate tab while you read
this. This blog post provides an overview, but the docs provide more
exhaustive detail.

## How to install beets

You can install beets with a package manager, either the one your
operating system provides or a Python package manager like `pip`.

If you use [OpenBSD](https://www.openbsd.org), you can install beets
with `pkg_add`:

    # pkg_add beets

## How to configure beets

By default, beets places imported music in `~/Music`. If you need to
change that, add the desired path to the `config.yaml` file like so:

    directory: /path/to/music/library

Often you can go straight to importing music without any further
modifications after this. Otherwise, the documentation on configuration
can help you if you run into any issues.

## How to import music

Beets needs a music library to work with, which means you need to import
some music.

    $ beet import /path/to/album

If the similarity score meets the threshold, beets tags the music
automatically and moves on. Otherwise, beets asks for more details.

## How to query music

To list your music, use `beet ls`. But beware: this lists _all_ music
currently managed by beets.

To narrow down your query, you can use the available metadata fields.
You can list those metadata fields with `beet fields`. The output
includes fields like `album`, `artist`, `year`, `country`, and others.

Some plugins provide metadata fields as well. For instance, with the
[lastgenre plugin](#genre-metadata-with-lastgenre) installed, you can
query by genre like this.

    $ beet ls genre:'Progressive Rock'

## What plugins does beets have?

Beets includes many high quality plugins that extend its capabilities. I
show only a fraction of them here, so make sure to read through the
documentation on plugins afterward.

### Album art with fetchart

If you use a minimal music player without album art display
capabilities, then this may not matter to you. Still, with more
full-featured media applications, missing artwork bothers some people.

To fetch album art with the fetchart plugin, add the following to your
`config.yaml`:

    plugins: fetchart

Then, update the library.

    $ beet fetchart

### Genre metadata with lastgenre

Out of the box, beets doesn't deal with genres at all because
MusicBrainz doesn't have that information.

To add genre information to your collection by pulling it from
[Last.fm](https://www.last.fm/), put this inside your `config.yaml`:

    plugins: lastgenre

Then, update the library.

    $ beet lastgenre

## Cue sheets and how to use them

Beets needs a separate file for each track to tag music. Yet sometimes
only one Free Lossless Audio Codec (FLAC) file exists for an entire
album. Although many other formats besides FLAC exist, pretend for now
that your album came with one FLAC file that contains all the tracks.

In this case, look for a text file that describes the album's track
layout with timestamps. People refer to a text file like this as a "cue
sheet." With a cue sheet, you can split that single FLAC file into
separate files by track, through a process known as "cue splitting."

Given a cue sheet and a FLAC file with many tracks, you can perform cue
splitting like this.

1.  Install `shntool` for cue splitting, and `cuetools` to tag the
    resulting files.

        # pkg_add shntool cuetools

2.  Navigate to the album in question.

        $ cd /path/to/album

3.  Split the FLAC file.

        $ shnsplit -f example.cue -o flac example.flac

    `-f` points to the cue sheet. `-o` specifies the encoder, which
    defaults to Waveform Audio File Format (WAV).

    By default, `shnsplit` creates files with this format:
    `split-track01.flac`. `beet import` renames files according to their
    metadata, so the filenames don't matter.

4.  Rename the FLAC file so that it ends in `.bak`.

        $ mv example.flac{,.bak}

    You need to perform this step so that cuetag won't target the
    original FLAC file later on.

5.  Tag the split files with the original metadata.

        $ cuetag example.cue ./*.flac

    `./*.flac` targets all FLAC files in the current directory. See
    [shellcheck's wiki entry for
    SC2035](https://github.com/koalaman/shellcheck/wiki/SC2035) for an
    explanation of why I use `./*.flac` instead of `*.flac`.

6.  If satisfied, delete the original FLAC file.

        $ rm example.flac.bak

7.  Now that you performed cue splitting, you can import the music.

        $ beet import .

### Scripting cue splitting

Given that this process can feel tedious, [I wrote a small shell
script](https://github.com/maybebyte/dotfiles/blob/e3b9752f26812326e194d2d7db5c273a13ee5759/.local/bin/splitflac)
to automate cue splitting. `splitflac` works like so:

    $ splitflac example.cue example.flac

By default, `splitflac` doesn't delete the original FLAC file. To do so
on a successful split, pass `-d`.

    $ splitflac -d example.cue example.flac
