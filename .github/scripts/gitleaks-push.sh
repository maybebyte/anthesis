#!/bin/sh
# gitleaks-push.sh — secret scan for the pre-push hook.
#
# When pre-commit provides the pushed range (PRE_COMMIT_FROM_REF/TO_REF,
# set at the pre-push stage), scan just those commits: anything older is
# already public, so re-scanning ~1,100 commits on every push adds
# latency, not protection. Without a range — CI's
# `pre-commit run --all-files --hook-stage pre-push`, or a manual run —
# fall back to full history, which keeps the exhaustive scan in CI.
#
# gitleaks comes from the hook's golang environment, which pre-commit
# puts on PATH.

set -eu

from=${PRE_COMMIT_FROM_REF:-}
to=${PRE_COMMIT_TO_REF:-}

if [ -n "$from" ] && [ -n "$to" ] &&
  git rev-parse --verify --quiet "$from^{commit}" > /dev/null; then
  exec gitleaks git --redact --verbose --log-opts="$from..$to"
fi

exec gitleaks git --redact --verbose
