# Gentoo one-liners for a rainy day

## Prerequisites

Install the necessary Portage utilities and GNU Parallel:

```sh
emerge -av app-portage/portage-utils app-portage/gentoolkit sys-process/parallel
```

## Finding packages with the most dependencies

Show which packages pull in the greatest number of dependencies:

```sh
qlist -CI | sort -u | parallel 'echo $(qdepends -CqqQ {} | wc -l) {}' | sort -n > pkgs_with_most_deps.txt
```

Here's what each part does:

- `qlist -CI`: Lists all installed packages without color output in
  `category/package` format.
- `sort -u`: Sorts output and removes duplicate entries.
- `parallel`: Runs dependency counting through GNU Parallel for better performance.
- `qdepends -CqqQ {}`: Queries dependencies without color output, quietly.
- `wc -l`: Counts the dependency lines.
- `sort -n`: Sorts numerically by dependency count.

The output shows dependency count followed by package name, from
packages with the least dependencies to greatest.

## Finding the largest packages

Find which packages consume the most storage:

```sh
qlist -CI | sort -u | parallel qsize -C | awk '{print $NF,$1}' | cut -d ':' -f 1 | sort -h > biggest_pkgs.txt
```

Breaking this down:

- `qsize -C`: Reports package sizes in human-readable format without color output.
- `awk '{print $NF,$1}'`: Reorders output to put size first, then package name.
- `cut -d ':' -f 1`: Removes trailing colon.
- `sort -h`: Sorts by human-readable numbers (handles K, M, G suffixes).

This arranges packages from smallest to largest.

## Combining package size and dependency count

Merge dependency and size data in one file for analysis:

```sh
join -j 2 -o 1.1,2.1,0 <(sort -k2 pkgs_with_most_deps.txt) <(sort -k2 biggest_pkgs.txt) | sort -n | tr ' ' '\t' > combined.txt
```

The `join` command joins lines of two files on a common field:

- `-j 2`: Join on field 2 (package names).
- `-o 1.1,2.1,0`: Output format (dependencies, size, package name).
- `<(sort -k2 ...)`: Process substitution with secondary key sorting.
- `tr ' ' '\t'`: Converts spaces to tabs for cleaner formatting.

## Print packages without a package.env entry

Print out packages that haven't been customized in
`/etc/portage/package.env`:

```sh
comm -13 <(awk 'match($1, /^[a-zA-Z0-9_+-]+\/[a-zA-Z0-9_+-]+$/) {print $1}' /etc/portage/package.env/* | sort -u) <(qlist -CI | sort -u)
```

This `comm` usage compares sorted lists:

- `-13`: Shows only lines unique to installation.
- `awk 'match($1, /^[a-zA-Z0-9_+-]+\/[a-zA-Z0-9_+-]+$/)'`: Grabs package
  in `category/package` format.

## As above, but only larger packages

Focus on packages large enough to warrant optimization attention:

```sh
comm -13 <(awk 'match($1, /^[a-zA-Z0-9_+-]+\/[a-zA-Z0-9_+-]+$/) {print $1}' /etc/portage/package.env/* | sort -u) <(qlist -CI | sort -u) | grep -f - combined.txt | awk 'match($2, /^([0-9]{4}\.[0-9]K)|([0-9]+\.[0-9][MG])$/)' | sort -n
```

This adds size filtering:

- `grep -f -`: Uses the uncustomized package list as search patterns.
- `awk 'match($2, /^([0-9]{4}\.[0-9]K)|([0-9]+\.[0-9][MG])$/)'`: Matches
  packages >=1000K.
- The regex captures four-digit kilobyte values or any megabyte/gigabyte values.

## Analyzing upgradable packages

Find packages that aren't customized in `/etc/portage/package.env` and
are already due for an upgrade anyway:

```sh
comm -13 <(awk 'match($1, /^[a-zA-Z0-9_+-]+\/[a-zA-Z0-9_+-]+$/) {print $1}' /etc/portage/package.env/* | sort -u) <(EIX_LIMIT=0 eix -u -# | sort -u)
```

This targets upgradable packages:

- `EIX_LIMIT=0`: Removes eix output limits.
- `eix -u -#`: Lists upgradable packages in `category/package` format.

## Multi-column sorting

Use multiple keys for different analysis priorities:

```sh
sort -k1,1n -k2,2h combined.txt
sort -k2,2h -k1,1n combined.txt
```

The first command prioritizes dependency count, using size as a
tiebreaker. The second makes size the primary criterion. The `h` and `n`
are for human-readable and numeric sorting.

## Practical applications

These commands help to identify large packages that could be replaced
with lightweight alternatives, which can be useful for a number of
reasons:

- Freeing up storage space.
- Creating a more minimal system.

When I was using these commands, it was to guide CFLAGS tweaking to
better optimize Gentoo in a VM, since virtual machines have limited
resources. I use a setup where video playback cannot benefit from
hardware acceleration (Qubes OS), so I was seeing if this approach could
make a difference. I think I did manage to gain a few FPS from this, but
as I didn't benchmark it beyond comparing frame timings in mpv and the
gain is relatively minor (<=10fps), I have no solid proof.

Though with that said, I should mention that these days I really believe
in benchmarking and profiling, as they make a huge difference. The gains
from those techniques is typically far greater than CFLAGS tweaking.
