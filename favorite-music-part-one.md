# Favorite music: part one

Hey, all. This is intended to be a set of articles on the side for when
I'm not up to writing something more academic, but still want to put
something out there.

The genres are based on MusicBrainz tags for the entire album. If
anything looks funky, I'm listing it as is, but may not fully agree that
that song in particular fits that genre.

These won't be released consistently--the point in my mind is to have
fun with it and publish these when it feels right.

If there's music you think I might enjoy, [feel free to contact
me](/contact.html). I'm always looking for new music and my tastes are
fairly eclectic.

## Now to the music

- [Aphex Twin - Heliosphan](https://www.youtube.com/watch?v=0Z4cLmbw6q0) (IDM) [(invidious)](https://vid.puffyan.us/watch?v=0Z4cLmbw6q0)

- [Tame Impala - Borderline](https://www.youtube.com/watch?v=2g5xkLqIElU) (Psychedelic Pop) [(invidious)](https://vid.puffyan.us/watch?v=2g5xkLqIElU)

- [Starset - Point of No Return](https://www.youtube.com/watch?v=_NTfbLtXTlw) (Progressive Metal) [(invidious)](https://vid.puffyan.us/watch?v=_NTfbLtXTlw)

- [Of Mice & Men - Ben Threw](https://www.youtube.com/watch?v=TVvfzz4-sxY) (Post-Hardcore) [(invidious)](https://vid.puffyan.us/watch?v=TVvfzz4-sxY)

- [Asking Alexandria - The Black](https://www.youtube.com/watch?v=b1RKaRgVFKk) (Metalcore) [(invidious)](https://vid.puffyan.us/watch?v=b1RKaRgVFKk)

- [Crystal Castles - Reckless](https://www.youtube.com/watch?v=thflPl1-4uE) (Electronic) [(invidious)](https://vid.puffyan.us/watch?v=thflPl1-4uE)

- [The Birthday Massacre - Goodnight](https://www.youtube.com/watch?v=0qjJmBX0c6A) (Industrial Rock) [(invidious)](https://vid.puffyan.us/watch?v=0qjJmBX0c6A)

- [Porcupine Tree - Heartattack in a Layby](https://www.youtube.com/watch?v=aiQPNlaAJPM) (Progressive Rock) [(invidious)](https://vid.puffyan.us/watch?v=aiQPNlaAJPM)

## Using mpv to stream them all

A quick note before the commands: I'm using brace expansion in the shell
to shorten the commands. To briefly show what this does, here are two
commands with identical output.

```
$ echo bat cat rat
bat cat rat
```

```
$ echo {b,c,r}at
bat cat rat
```

### Streaming from YouTube

```
$ mpv --no-video https://www.youtube.com/watch?v={0Z4cLmbw6q0,2g5xkLqIElU,_NTfbLtXTlw,TVvfzz4-sxY,b1RKaRgVFKk,thflPl1-4uE,0qjJmBX0c6A,aiQPNlaAJPM}
```

### Streaming from Invidious

```
$ mpv --no-video https://vid.puffyan.us/watch?v={0Z4cLmbw6q0,2g5xkLqIElU,_NTfbLtXTlw,TVvfzz4-sxY,b1RKaRgVFKk,thflPl1-4uE,0qjJmBX0c6A,aiQPNlaAJPM}
```
