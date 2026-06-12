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
# (c) every tracked HTML template that references hashed assets agrees
#     with the others on the tokens it references — templates are
#     discovered, not hardcoded, so a new template cannot escape the
#     check (compared by basename, since templates may legitimately use
#     different path prefixes for the same asset);
# (d) every tracked hashed asset is referenced by at least one tracked
#     text file — otherwise it is orphaned: published with the site but
#     reachable by nothing.
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

# Vendored trees never count as reference sources: FONTLOG.txt holds
# historical commit-pinned permalinks whose tokens are valid but stale.
# Word-split deliberately when passed to git.
vendored_pathspecs=':!fonts/ :!stagit/ :!migration/ :!pubkeys/'

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

# shellcheck disable=SC2086 # vendored_pathspecs must word-split
for src in $(git grep -I -l -E '\.[0-9a-f]{64}\.' -- $vendored_pathspecs); do
  for ref in $(refs "$src"); do
    [ -f "${ref#/}" ] || fail "$src references missing asset: $ref"
  done
done

# --- (d) every tracked hashed asset is referenced somewhere ----------------
# One grep collects every .<token>. occurrence in tracked text files; an
# asset whose token never appears is orphaned. Reference chains satisfy
# this naturally (fonts are reachable via the hashed stylesheets).
# shellcheck disable=SC2086 # vendored_pathspecs must word-split
referenced=$(git grep -I -h -oE '\.[0-9a-f]{64}\.' -- $vendored_pathspecs | sort -u)
for f in $(git ls-files | grep -E '\.[0-9a-f]{64}\.' || true); do
  tok=$(expr "$f" : '.*\.\([0-9a-f]\{64\}\)\.')
  case "$referenced" in
    *".$tok."*) ;;
    *) fail "orphaned hashed asset (referenced by nothing): $f" ;;
  esac
done

# --- (c) HTML templates reference identical hash tokens --------------------
tokens() {
  refs "$1" | sed 's|.*/||' | sort -u
}

templates=$(git grep -I -l -E '\.[0-9a-f]{64}\.' -- '*.html' || true)

# Guard against the check silently degrading: these two must always be in
# the discovered set.
for required in _header.html errdocs/err.html; do
  printf '%s\n' "$templates" | grep -qx "$required" ||
    fail "expected template missing from agreement check: $required"
done

base_file=''
base_tokens=''
for t in $templates; do
  if [ -z "$base_file" ]; then
    base_file=$t
    base_tokens=$(tokens "$t")
    continue
  fi
  t_tokens=$(tokens "$t")
  if [ "$t_tokens" != "$base_tokens" ]; then
    fail "$base_file and $t disagree on hashed assets:"
    printf '%s\n' "--- $base_file:" "$base_tokens" \
      "--- $t:" "$t_tokens" >&2
  fi
done

exit "$status"
