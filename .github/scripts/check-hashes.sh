#!/bin/sh
# check-hashes.sh — integrity checks for content-hashed assets.
#
# (a) every tracked file with a .<sha256>. token in its name hashes to
#     exactly that token;
# (b) every hashed asset referenced by any tracked text file (templates,
#     stylesheets, articles) exists on disk — referencing files are
#     discovered, not hardcoded, so renames cannot leave stale references
#     behind; vendored trees are skipped (FONTLOG.txt holds historical
#     commit-pinned permalinks that are valid but not present on disk);
# (c) _header.html and errdocs/err.html agree on the hash tokens they
#     reference (compared by basename, since the two files may legitimately
#     use different path prefixes for the same asset).
#
# Word-splitting over `git ls-files` output is safe here: tracked names in
# this repo contain no whitespace.

set -eu

cd "$(git rev-parse --show-toplevel)"

status=0
fail() {
  printf 'check-hashes: %s\n' "$1" >&2
  status=1
}

# --- (a) filename hash matches content hash --------------------------------
for f in $(git ls-files | grep -E '\.[0-9a-f]{64}\.' || true); do
  # Extract the hash by pattern, not positional dot-splitting: several
  # images carry a double suffix (name.<hash>.2.png) that naive ${f%.*}
  # parsing mishandles.
  want=$(expr "$f" : '.*\.\([0-9a-f]\{64\}\)\.')
  got=$(sha256sum "$f" | cut -d' ' -f1)
  [ "$want" = "$got" ] || fail "content hash mismatch: $f (actual: $got)"
done

# --- (b) referenced hashed assets exist on disk ----------------------------
refs() {
  grep -oE '[A-Za-z0-9_/.-]*\.[0-9a-f]{64}\.[A-Za-z0-9.]+' "$1" | sort -u
}

for src in $(git grep -I -l -E '\.[0-9a-f]{64}\.' -- \
  ':!fonts/' ':!stagit/' ':!migration/' ':!pubkeys/'); do
  for ref in $(refs "$src"); do
    [ -f "${ref#/}" ] || fail "$src references missing asset: $ref"
  done
done

# --- (c) header and errdocs reference identical hash tokens ----------------
for src in _header.html errdocs/err.html; do
  [ -f "$src" ] || fail "expected template missing: $src"
done

tokens() {
  refs "$1" | sed 's|.*/||' | sort -u
}

header_tokens=$(tokens _header.html)
err_tokens=$(tokens errdocs/err.html)
if [ "$header_tokens" != "$err_tokens" ]; then
  fail '_header.html and errdocs/err.html disagree on hashed assets:'
  printf '%s\n' '--- _header.html:' "$header_tokens" \
    '--- errdocs/err.html:' "$err_tokens" >&2
fi

exit "$status"
