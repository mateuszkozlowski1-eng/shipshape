#!/usr/bin/env bash
# Shipshape installer for macOS and Linux (also works in Git Bash on Windows).
# Usage: ./install.sh [project-folder] [--no-hook] [--update-skills]
set -euo pipefail

KIT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target="."
hook=1
update_skills=0

usage() {
  cat <<'EOF'
Usage: ./install.sh [project-folder] [--no-hook] [--update-skills]

  project-folder    where to install (default: current folder)
  --no-hook         don't install the secret-scan pre-commit hook
  --update-skills   replace the skill files with this version's (your AGENTS.md and DECISIONS.md stay)
EOF
}

for arg in "$@"; do
  case "$arg" in
    --no-hook) hook=0 ;;
    --update-skills) update_skills=1 ;;
    -h | --help) usage; exit 0 ;;
    -*) echo "Unknown option: $arg" >&2; usage >&2; exit 2 ;;
    *) target="$arg" ;;
  esac
done

[ -d "$target" ] || { echo "No such folder: $target" >&2; exit 1; }
target="$(cd "$target" && pwd)"
[ "$target" != "$KIT" ] || { echo "That's the Shipshape folder itself. Point me at your project folder." >&2; exit 1; }

echo "Installing Shipshape into $target"
skipped=0

copy() { # copy <source> <relative destination> <overwrite: 0|1>
  local src="$1" rel="$2" overwrite="$3" dst="$target/$2"
  if [ -e "$dst" ]; then
    if [ "$overwrite" = 1 ]; then
      cp "$src" "$dst"; echo "  updated  $rel"
    else
      echo "  kept     $rel (already there)"; skipped=1
    fi
  else
    mkdir -p "$(dirname "$dst")"; cp "$src" "$dst"; echo "  added    $rel"
  fi
}

for f in AGENTS.md CLAUDE.md DECISIONS.md; do
  copy "$KIT/kit/$f" "$f" 0
done

while IFS= read -r src; do
  copy "$src" "${src#"$KIT/kit/"}" "$update_skills"
done < <(find "$KIT/kit/.agents" -type f | sort)

# Keep env files out of git.
gi="$target/.gitignore"
if ! { [ -f "$gi" ] && grep -Eq '^/?\.env(\*|\.\*|\.local)?$' "$gi"; }; then
  { [ -s "$gi" ] && [ -n "$(tail -c1 "$gi")" ] && echo; printf '# Secrets (added by Shipshape)\n.env\n.env.*\n!.env.example\n'; } >> "$gi"
  echo "  updated  .gitignore (env files)"
fi

# Secret-scan pre-commit hook.
if [ "$hook" = 1 ]; then
  if ! git -C "$target" rev-parse --git-dir > /dev/null 2>&1; then
    echo "  no hook  not a git repository yet (run 'git init', then install again for the hook)"
  elif hooks_path="$(git -C "$target" config core.hooksPath)" && [ -n "$hooks_path" ]; then
    echo "  no hook  this repo uses its own hooks folder ($hooks_path, e.g. husky)."
    echo "           Call $KIT/hooks/pre-commit from your pre-commit hook to add the secret scan."
  else
    hooks_dir="$(cd "$target" && cd "$(git rev-parse --git-path hooks)" 2> /dev/null && pwd || true)"
    if [ -z "$hooks_dir" ]; then
      hooks_dir="$(cd "$target" && git rev-parse --absolute-git-dir)/hooks"; mkdir -p "$hooks_dir"
    fi
    dst="$hooks_dir/pre-commit"
    if [ -e "$dst" ] && ! grep -q 'Shipshape secret scan' "$dst"; then
      echo "  no hook  a pre-commit hook already exists; add a call to $KIT/hooks/pre-commit to it"
    else
      cp "$KIT/hooks/pre-commit" "$dst"; chmod +x "$dst"; echo "  added    pre-commit hook (secret scan)"
    fi
  fi
fi

if [ "$skipped" = 1 ]; then
  echo
  echo "Some files were already there and were kept. If you had your own AGENTS.md or CLAUDE.md,"
  echo "merge what you want from $KIT/kit/AGENTS.md, and make sure CLAUDE.md contains the line @AGENTS.md."
fi

cat <<'EOF'

Done. Next: open your AI agent in the project and say:

    Read AGENTS.md and run the setup skill.

EOF
