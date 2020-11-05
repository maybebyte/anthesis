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

## Cue splitting

Beets needs a separate file for each track in order to tag music, yet
some releases have only one FLAC file for the entire album.
Fortunately, the lone FLAC file can be split given an appropriate cue
sheet (a text file that describes the album's track layout).

1. Install `shntool` for cue splitting and `cuetools` to tag the
   resulting files.

        # pkg_add shntool cuetools

1. Split the FLAC file.  `-f` specifies the cue sheet, `-o` is the
   encoder (`shnsplit` uses WAV by default), and `-t` is the output
   format (track number + title).

        $ shnsplit -f example.cue -o flac -t "%n %t" example.flac

1. Append a `.bak` extension to the FLAC file.  This is needed for the
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

## Configuring beets (if needed)

By default, beets imports music to `~/Music`. If this fits your use
case, feel free to skip this section. My music is located at
`/mnt/music` since I use an external drive to store it, so I added
this to my `config.yaml` file:

    directory: /mnt/music

Chances are that you won't need to modify anything else. Otherwise, see
[Configuration](https://beets.readthedocs.io/en/stable/reference/config.html).

## Importing music

Importing music is pretty simple.

    beet import [album name]

`beet import` prompts the user for additional details if needed. If the
similarity score is high enough, beets tags the music automatically
and moves on.

However, sometimes beets matches something very similar that isn't 100%
correct. The release date or record label might be wrong, for instance.
I use `-t` (timid) and go to the effort to check the URL. If it isn't
right, I navigate to the correct release on
[MusicBrainz](https://musicbrainz.org/) by clicking on *(see all versions of
this release, X available)*. Then, I enter the ID (found in the URL) into
the prompt.

If `-t` is used consistently, consider setting the equivalent option in
`config.yaml`:

    import:
      timid: yes

## Other nice things

There are advantages to using beets other than correct metadata. Beets
can output statistics and perform queries, for instance. To list all
music that matches a specific genre, use `beet ls`.

    beet ls genre:"Progressive Rock"

Quoting isn't strictly necessary. I do it out of habit.
