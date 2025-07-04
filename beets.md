# Tagging and managing music with beets

Last updated: July 4th, 2025

## Why metadata matters

Tagged music files come with significant benefits. To name just a few:

- You know what to expect from your music without relying on mile-long
  filenames or navigating through a forest of directories.

- You can find what you're looking for by querying the metadata.

- ReplayGain normalizes loudness so that your hand can rest somewhere
  other than the volume knob.

## Beets as a music manager

If you're new to tagging music or want to change your workflow, maybe
you can [use beets to manage your library](https://beets.io/). By
fetching and applying metadata from
[MusicBrainz](https://musicbrainz.org/), you can achieve what I
mentioned earlier.

You may like to keep [the documentation for
beets](https://beets.readthedocs.io) in a separate tab while you read
this. This blog post provides an overview; the docs provide more
exhaustive details.

## How to install beets

You can probably install beets with the package manager your operating
system uses. Here's how to install it on
[OpenBSD](https://www.openbsd.org).

    # pkg_add beets

## How to configure beets

By default, beets places imported music in `~/Music`. If you need to
change that, add the desired path to the `config.yaml` file like so:

    directory: /path/to/music/library

Chances are that you can go straight to importing music without any
further modifications. Otherwise, the documentation on configuration can
help you if you run into any issues.

## How to import music

To be useful, beets needs a library to work with. That means you need to
import some music.

    $ beet import /path/to/album

If the similarity score meets the threshold, beets tags the music
automatically and moves on. Otherwise, beets asks for more details.

## How to query music

To sift through some of your music, use `beet ls`.

Narrow down your query with the available metadata fields. This includes
things like `genre`, `artist`, `album`, `year`, `country`, and others.

Here's an example where I query by genre (note that you need to use the
lastgenre plugin for this to work. [I mention that plugin later
on](#genre-metadata-with-lastgenre)).

    $ beet ls genre:'Progressive Rock'

As a side note, you can list available metadata fields with `beet
fields`.

## What plugins does beets have?

Beets includes many high quality plugins that extend its capabilities. I
show only a fraction of what's possible here, so make sure to read
through the documentation on plugins afterward.

### Album art with fetchart

If you use a minimal music player like I do, then this may not matter as
much to you. Still, with more full-featured media applications, missing
artwork bothers some people.

To fix this, add the following to your `config.yaml`:

    plugins: fetchart

Then, update the library.

    $ beet fetchart

### Genre metadata with lastgenre

Out of the box, beets doesn't deal with genres at all because
MusicBrainz doesn't have that information.

To add genre information to your collection by pulling from
[Last.fm](https://www.last.fm/), put this inside your `config.yaml`:

    plugins: lastgenre

Then, update the library.

    $ beet lastgenre

## Cue sheets and how to use them

Beets needs a separate file for each track to tag music, yet sometimes
there's only one FLAC (Free Lossless Audio Codec) file for the entire
album. It can also be another format, but for this example I'll assume
it's a FLAC file.

The nice thing is, as long as you have a cue sheet---a text file that
describes the album's track layout with timestamps---you can split that
single FLAC file into separate files by track ("cue splitting").

Here's how I split a file like this into tracks given a cue sheet.

1.  Install `shntool` for cue splitting, and `cuetools` to tag the
    resulting files.

        # pkg_add shntool cuetools

2.  Navigate to the album in question.

        $ cd /path/to/album

3.  Split the FLAC file.

    `-f` points to the cue sheet. `-o` specifies the encoder, which
    defaults to WAV (Waveform Audio File Format).

    By default, the output format looks like `split-track01.flac`. Beets
    renames files according to metadata anyway, so the name doesn't
    matter much.

        $ shnsplit -f example.cue -o flac example.flac

4.  Rename the FLAC file so that it ends in `.bak`.

    You need to perform this step so that cuetag won't target the
    original FLAC file later on.

        $ mv example.flac{,.bak}

5.  Tag the split files with the original metadata.

    `./*.flac` targets all FLAC files in the current directory. See
    [shellcheck's wiki entry for
    SC2035](https://github.com/koalaman/shellcheck/wiki/SC2035) for an
    explanation of why I use `./*.flac` instead of `*.flac`.

        $ cuetag example.cue ./*.flac

6.  If satisfied, delete the original FLAC file.

        $ rm example.flac.bak

7.  Now that everything has been split into tracks, you can import the music.

        $ beet import .

### Scripting cue splitting

Given that this process can be tedious, [I wrote a small shell
script](https://github.com/maybebyte/dotfiles/blob/e3b9752f26812326e194d2d7db5c273a13ee5759/.local/bin/splitflac)
to take care of splitting FLAC files for me. `splitflac` works like so:

    $ splitflac example.cue example.flac

By default, `splitflac` doesn't delete the original FLAC file. To do so
on a successful split, pass `-d`.

    $ splitflac -d example.cue example.flac
