#!/usr/bin/env bash
# Record that a blog post passed its clarity review (see "Clarity check before publishing"
# in CLAUDE.md). Run it only after the newcomer read is done and every finding is fixed.
# The stamp is the git blob hash of the post now; any later edit invalidates it, and the
# clarity-gate hook then blocks the commit until the post is reviewed and stamped again.
set -euo pipefail
[ $# -ge 1 ] || { echo "usage: scripts/clarity-stamp.sh src/content/blog/<post>.md ..." >&2; exit 1; }
root=$(git rev-parse --show-toplevel)
mkdir -p "$root/.claude/clarity"
for f in "$@"; do
  [ -f "$f" ] || { echo "no such file: $f" >&2; exit 1; }
  stamp="$root/.claude/clarity/$(basename "$f" .md).sha"
  git hash-object "$f" > "$stamp"
  echo "stamped $f -> ${stamp#$root/}"
done
