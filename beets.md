# Perfecting your metadata: tagging music with beets

It's wonderful to have a music library with correct metadata. In my
case, I use [NCMPCPP](https://rybczak.net/ncmpcpp/ "NCurses Music Player C++")
to search by artist, title, album, genre, date, etc.

Of course, this requires everything to be tagged properly; the future
has a surprise in store for you if your metalcore collection is
erroneously marked as "easy listening."

Avoid that predicament by using [beets](https://beets.io/). From the
project's website:
>"Beets is the media library management system for obsessive music geeks."

## Configuring beets (if needed)

By default, beets imports music to `~/Music`. If this fits your use
case, feel free to skip this section. Otherwise, add the path of your
music library to the `config.yaml` file:

    directory: /path/to/music/library

Chances are that you won't need to modify anything else. Otherwise, see
[Configuration](https://beets.readthedocs.io/en/stable/reference/config.html).

## Importing music

In order to be useful, beets needs a library to work with, and that
means importing music. Fortunately, importing music is pretty simple.

    $ beet import /path/to/album

`beet import` prompts the user for additional details if needed. If the
similarity score is high enough, beets tags the music automatically
and moves on.

## Querying music

To list music, use `beet ls`. Beets can narrow down the query via a
plethora of metadata fields (`genre`, `artist`, `album`, `year`,
`country`, and so on).

    $ beet ls genre:"Progressive Rock"

Quoting isn't strictly necessary. I do it out of habit.

To list the available metadata fields, use `beet fields`.

## Plugins

[There are high quality plugins available for
beets](https://beets.readthedocs.io/en/stable/plugins/) that extend its
functionality and sweeten the deal even more. I won't list all of them
here, but I'll include a couple examples for demonstrative purposes.

### Album art

Ordinarily, this wouldn't matter to me too much as I primarily use
[NCMPCPP](https://rybczak.net/ncmpcpp/ "NCurses Music Player C++") +
[MPD](https://www.musicpd.org/ "Music Player Daemon") to play music.
However, with more full-featured applications like
[Kodi](https://kodi.tv/), missing artwork sticks out like a sore thumb
to me.

Fortunately, there's an easy fix for this. Make certain the following is
in `config.yaml`:

    plugins: fetchart

Then, update your library.

    $ beet fetchart

See [the documentation for
fetchart](https://beets.readthedocs.io/en/stable/plugins/fetchart.html) for more details.

### Genre

MusicBrainz actually doesn't contain genre information, so I use a
plugin for this, too. Ensure that you place the appropriate entry under
`plugins` in `config.yaml`:

    plugins: lastgenre

Then, update your library.

    $ beet lastgenre

See [the documentation for
lastgenre](https://beets.readthedocs.io/en/stable/plugins/lastgenre.html)
for more details.

## When beets is beat

Beets handles most everything well. In some situations, however, I had
to gently coax it into understanding what I wanted it to do.

### Dealing with false positives

Sometimes beets makes mistakes (particularly when operating without the
[chroma
plugin](https://beets.readthedocs.io/en/stable/plugins/chroma.html)).
Even with acoustic fingerprinting, certain things may be off. The
release date, record label, or country might be wrong, for instance. I
use `-t` (timid) for this reason.

If `-t` is used consistently, consider setting the equivalent option in
`config.yaml`.

    import:
      timid: yes

### Cue splitting

Beets needs a separate file for each track in order to tag music, yet
some releases have only one FLAC file for the entire album.
Fortunately, the lone FLAC file can be split given an appropriate cue
sheet (a text file that describes the album's track layout).

1. Install `shntool` for cue splitting and `cuetools` to tag the
   resulting files.

        # pkg_add shntool cuetools

1. Navigate to the album in question.

        $ cd /path/to/album

1. Split the FLAC file. `-f` specifies the cue sheet, `-o` is the
   encoder (`shnsplit` uses WAV by default), and `-t` is the output
   format (track number + title).

        $ shnsplit -f example.cue -o flac -t "%n %t" example.flac

1. Append a `.bak` extension to the FLAC file. This is needed for the
   next step so that the original FLAC file won't be targeted by
   `cuetag`.

        $ mv example.flac{,.bak}

1. Tag the split files with the original metadata. `./*.flac` targets
   all FLAC files in the current directory (see
   [SC2035](https://github.com/koalaman/shellcheck/wiki/SC2035) for an
   explanation of why I use `./*.flac` instead of `*.flac`).

        $ cuetag example.cue ./*.flac

1. If satisfied, delete the original FLAC file.

        $ rm example.flac.bak

Given that this is a bit tedious, I [wrote a small shell
script](/src/dotfiles/file/.local/bin/splitflac.html)
to take care of it for me. Usage is as follows:

    $ splitflac example.cue example.flac

By default, `splitflac` doesn't delete the original FLAC file. To do so
if the other commands succeed, pass the `-d` flag.

    $ splitflac -d example.cue example.flac
