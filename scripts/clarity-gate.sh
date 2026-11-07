#!/usr/bin/env bash
# Claude Code PreToolUse hook (Bash): block `git commit` when a published blog post
# (src/content/blog/*.md with draft: false) is being committed without an up-to-date
# clarity-review stamp. A stamp is the git blob hash of the post as it was when the
# clarity review passed, written by scripts/clarity-stamp.sh into .claude/clarity/.
# Any edit after the review changes the hash, so the post must be reviewed again.
# Emergency bypass: start the command with CLARITY_SKIP=1.
set -euo pipefail

cmd=$(jq -r '.tool_input.command // empty')
case "$cmd" in
  *"git commit"*) ;;
  *) exit 0 ;;
esac
case "$cmd" in
  *CLARITY_SKIP=1*) exit 0 ;;
esac

root=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
cd "$root"

# Files this commit will take: the staged ones, plus modified tracked ones with -a/--all.
files=$(git diff --cached --name-only --diff-filter=AM -- 'src/content/blog/*.md')
all=0
case "$cmd" in
  *" -a "*|*" -a"|*" --all"*|*" -am "*|*" -am"*) all=1 ;;
esac
if [ "$all" = 1 ]; then
  files=$(printf '%s\n%s\n' "$files" "$(git diff --name-only --diff-filter=M -- 'src/content/blog/*.md')" | sort -u)
fi

missing=()
for f in $files; do
  [ -n "$f" ] || continue
  if [ "$all" = 1 ]; then content_hash=$(git hash-object "$f"); body=$(cat "$f")
  else content_hash=$(git rev-parse ":$f"); body=$(git show ":$f"); fi
  # Only published posts are gated; drafts may be committed freely.
  printf '%s\n' "$body" | awk 'NR==1 && /^---$/ {fm=1; next} fm && /^---$/ {exit} fm' | grep -qE '^draft:[[:space:]]*true' && continue
  stamp=".claude/clarity/$(basename "$f" .md).sha"
  if [ ! -f "$stamp" ] || [ "$(cat "$stamp")" != "$content_hash" ]; then
    missing+=("$f")
  fi
done

if [ "${#missing[@]}" -gt 0 ]; then
  {
    echo "BLOCKED: clarity review missing or out of date for published post(s):"
    for f in "${missing[@]}"; do echo "  - $f"; done
    echo
    echo "Follow 'Clarity check before publishing' in CLAUDE.md: run a fresh newcomer read"
    echo "of each post, fix every finding, then stamp it with:"
    for f in "${missing[@]}"; do echo "  scripts/clarity-stamp.sh $f"; done
    echo "(Stamps live in .claude/clarity/, which git ignores: they are local review records.)"
  } >&2
  exit 2
fi
exit 0
