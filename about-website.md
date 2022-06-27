# About amissing.link

## Conventions

1. `amissing.link` is also available as an [onion
   service](http://jentyxddh2rf47gd3e43kuebyn2xsv6h72gzh46oe4rxyovvm7xe5ead.onion/)
   for those that want/need more privacy. To access the onion service,
   use [Tor](https://www.torproject.org/).

1. Any word with a trailing number enclosed in parentheses, such as
   [`help(1)`](https://man.openbsd.org/help), is a link to a
   [`man(1)`](https://man.openbsd.org/man) page. The number represents
   the section number of that man page.

1. In command line examples, a dollar sign `($)` represents a shell
   without root permissions; conversely, an octothorpe `(#)` represents
   a shell with root permissions. Root can be acquired via
   [`su(1)`](https://man.openbsd.org/su) or
   [`doas(1)`](https://man.openbsd.org/doas), though the latter is
   preferred.

1. In command line examples, `[...]` is used as a placeholder for actual
   values. For instance, `usermod -G [group] [user]` means to substitute
   the desired group and user at those locations. Other placeholders are
   used in a similar fashion when needed, such as `/path/to/directory`
   or `example.cue`.

## How is amissing.link written?

I write `amissing.link` in [Markdown](https://www.markdownguide.org/)
with [neovim](https://neovim.io/). [ssg](https://rgz.ee/ssg.html) parses
the Markdown and generates corresponding HTML documents.
[rssg](https://rgz.ee/rssg.html) generates the RSS feed. Note that my
version of `ssg` and `rssg` differ from Roman's, though the changes
mostly come down to stylistic preferences.

To test layout, [`httpd(8)`](https://man.openbsd.org/httpd) runs on
`localhost` on my development machine. After I make changes, I run a
simple script named
[`webtest`](/src/dotfiles/file/.local/bin/webtest.html) to sync my
changes so that I can preview them before committing and pushing to the
server with git.

Once I push to the server,
[`post-receive`](/src/sysadm/file/post-receive.html) activates (see
[`githooks(5)`](https://git-scm.com/docs/githooks) for more info) to
render the Markdown and voilà.
