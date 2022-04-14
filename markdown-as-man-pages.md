# Read Markdown as man pages with lowdown(1) and mandoc(1)

My use case, broadly speaking, is similar to that of many others that
maintain a blog. I write my blog in
[Markdown](https://www.markdownguide.org/) and often want to check the
output to make sure that it's sane before applying changes.

Formerly, my way of addressing this was to run
[`httpd(8)`](https://man.openbsd.org/httpd) on `localhost` and use a
[shell script I wrote called
`webtest`](/src/dotfiles/file/.local/bin/webtest.html)
to render the output. Then, I would preview the changes in my web browser by
visiting `http://localhost/`.

I do still like this method for certain things, such as seeing how CSS
is going to look in Firefox. It's nice to have a completely local,
browsable copy of my website.[^1] However, for quickly ascertaining
whether the output for an article is good or not, this is totally
overkill!

This is where [`lowdown`](https://kristaps.bsd.lv/lowdown/) comes in.
`lowdown` has a number of different output modes that can be specified
with `lowdown -T [mode]`. `lowdown -T html` is typical for blogs.

One day, I got curious and read the man page to look for other output
modes and noticed `lowdown -T man`. Suddenly, it hit me that I could use
[`mandoc(1)`](https://man.openbsd.org/mandoc) to accept, format, and
paginate that output like so:

	$ lowdown -T man [Markdown file] | mandoc -a

So, it turns out I can [RTFM](https://knowyourmeme.com/memes/rtfm) even
when proofreading my website. I wrote a [small shell function named
`manmd()`](/src/dotfiles/file/.config/ksh/functions.html)
to make the process easier and for the novelty of it.

Output can be piped to something other than `mandoc` if preferred--I
use `mandoc` because it's included with OpenBSD.

## Other options for reading Markdown

It's worth perusing the respective man pages for interesting options.
Looking at `mandoc`, it's possible to render `lowdown -T man` output as
a PDF and pipe that into a PDF reader (I like
[`zathura`](https://pwmt.org/projects/zathura/)):

	$ lowdown -T man [Markdown file] | mandoc -T pdf | zathura -

There is also `lowdown -T term`, described as "ANSI-escaped UTF-8 output
suitable for reading on the terminal." Here, I paginate the output with
[`less(1)`](https://man.openbsd.org/less), with `-R` to correctly
interpret ANSI color escape sequences.

	$ lowdown -T term [Markdown file] | less -R

To disable ANSI color escape sequences (I find the added color doesn't enhance
readability; if anything, it's very distracting), use `--term-no-colour`:

	$ lowdown -T term --term-no-colour [Markdown file] | less

I also wrote a small shell function for the no color variant of `lowdown
-T term`, `readmd()`. It's less janky than `manmd()`, as entertaining as
Markdown converted into man pages can be.

[^1]: I realize one could get more or less the same effect without
      running a web server on `localhost` (by pointing Firefox at the HTML
      files directly), but I like this method better.  The application of
      [`unveil(2)`](https://man.openbsd.org/unveil) to the Firefox package
      in OpenBSD means that Firefox has limited permissions as to what it
      can read, write, execute, and create, and I don't want my website
      cluttering my `~/Downloads` folder.
