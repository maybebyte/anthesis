# About amissing.link

I maintain `amissing.link` for four main reasons:

1. A personal website is among the freest forms of expression a person
   can have.

1. Many sites these days are overengineered and/or hostile to those that
   value privacy. Developing and hosting a minimal, privacy-respecting
   website allows me to be the change I want to see in the world.

1. The act of sharing my discoveries sparks joy ([which means I get to
   keep them](https://knowyourmeme.com/memes/does-it-spark-joy)).
   Pursuing and disseminating knowledge is in itself meaningful to me.

1. Organizing my thoughts somewhere allows me to understand myself to a
   greater extent. Otherwise, they vanish into the ether.

This site and others like it are a missing link--a way to foster
thought, expression, and community. A place where connection can exist
and flourish without some company designing to line their pockets with
it. A gentle yet steadfast act of defiance against what the web has
become.

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
[`post-receive`](/src/sysadm/files/post-receive) activates (see
[`githooks(5)`](https://git-scm.com/docs/githooks) for more info) and
voilà.
