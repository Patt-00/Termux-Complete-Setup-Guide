#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INV="$ROOT/inventory"
PREFIX="${PREFIX:-/data/data/com.termux/files/usr}"
HOME_DIR="${HOME:-/data/data/com.termux/files/home}"
SDK="$HOME_DIR/android-sdk"
mkdir -p "$INV"

date -Iseconds > "$INV/captured-at.txt"

dpkg-query -W -f='${binary:Package}\t${Version}\t${Architecture}\t${db:Status-Abbrev}\n' \
  | awk -F '\t' '$4 ~ /^ii/ {print $1 "\t" $2 "\t" $3 "\tinstalled"}' \
  | sort > "$INV/packages.tsv"

apt-mark showmanual 2>/dev/null | while IFS= read -r package; do
  status="$(dpkg-query -W -f='${db:Status-Abbrev}' "$package" 2>/dev/null || true)"
  [[ "$status" == ii* ]] && printf '%s\n' "$package"
done | sort -u > "$INV/manual-packages.txt"

{
  first_source=1
  for source in "$PREFIX/etc/apt/sources.list" "$PREFIX"/etc/apt/sources.list.d/*.list; do
    [[ -f "$source" ]] || continue
    if [[ "$first_source" -eq 0 ]]; then printf '\n'; fi
    first_source=0
    printf '# %s\n' "${source#"$PREFIX"/etc/apt/}"
    cat "$source"
  done
} > "$INV/repositories.txt"

python -m pip list --format=json > "$INV/python-packages.json"
npm ls -g --depth=0 --json > "$INV/npm-global.json" 2>/dev/null || true

find "$HOME_DIR/.agents/skills" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' 2>/dev/null \
  | sort > "$INV/skills.txt"
{
  printf '# Cached plugin names and versions; this does not imply an account connection.\n'
  find "$HOME_DIR/.codex/plugins/cache/openai-curated-remote" -mindepth 2 -maxdepth 2 \
    -type d -printf '%P\n' 2>/dev/null | grep -v '^app-' | sort || true
  app_components="$(find "$HOME_DIR/.codex/plugins/cache/openai-curated-remote" -mindepth 1 -maxdepth 1 \
    -type d -name 'app-*' -print 2>/dev/null | wc -l | tr -d ' ')"
  printf 'App-specific cached components: %s\n' "$app_components"
} > "$INV/plugins.txt"

{
  printf 'SDK root: %s\n' "$SDK"
  printf '\nSDK Manager recognized packages:\n'
  if [[ -x "$SDK/cmdline-tools/latest/bin/sdkmanager" ]]; then
    "$SDK/cmdline-tools/latest/bin/sdkmanager" --sdk_root="$SDK" --list_installed 2>&1 \
      | tr -d '\r' | sed -n '/Installed packages:/,$p' | sed '/^$/q' \
      | sed -E 's/[[:space:]]+$//' || true
  else
    printf '(sdkmanager not found)\n'
  fi
  printf '\nsource.properties files present on disk:\n'
  if [[ -d "$SDK" ]]; then
    find "$SDK" -type f -name source.properties -print | sort | while IFS= read -r file; do
      relative="${file#"$SDK"/}"
      printf '\n[%s]\n' "$relative"
      grep -E '^(Pkg\.(Path|Revision|Desc)|AndroidVersion\.(ApiLevel|ExtensionLevel))=' "$file" || true
    done
  fi
} > "$INV/android-sdk.txt"

NDK_COMPAT="$HOME_DIR/termux-ndk-27.1.12297006"
if [[ -d "$NDK_COMPAT" ]]; then
  find "$NDK_COMPAT" -type l -printf '%P\t%l\n' | sort | while IFS=$'\t' read -r link target; do
    target="${target/"$PREFIX"/\$PREFIX}"
    target="${target/"$HOME_DIR"/\$HOME}"
    printf '%s -> %s\n' "$link" "$target"
  done > "$INV/ndk-symlinks.txt"
else
  : > "$INV/ndk-symlinks.txt"
fi

DISTROS="$INV/containers.txt"
: > "$DISTROS"
while IFS= read -r distro; do
  [[ -n "$distro" ]] || continue
  printf '%s\n' "$distro" >> "$DISTROS"
  case "$distro" in
    debian)
      proot-distro login "$distro" -- cat /etc/os-release > "$INV/debian-os-release.txt"
      proot-distro login "$distro" -- dpkg-query -W \
        '-f=${binary:Package}\t${Version}\t${Architecture}\n' \
        | sort > "$INV/debian-packages.tsv"
      ;;
    alpine)
      proot-distro login "$distro" -- cat /etc/os-release > "$INV/alpine-os-release.txt"
      proot-distro login "$distro" -- apk info -v | sort > "$INV/alpine-packages.txt"
      ;;
  esac
done < <(proot-distro list 2>&1 | sed -n '/Installed containers:/,/Log in with:/p' | sed -n 's/^  [*] //p')

printf 'Termux packages: %s\n' "$(wc -l < "$INV/packages.tsv" | tr -d ' ')" > "$INV/summary.txt"
printf 'Manual Termux packages: %s\n' "$(wc -l < "$INV/manual-packages.txt" | tr -d ' ')" >> "$INV/summary.txt"
printf 'Python packages: %s\n' "$(python -c 'import json,sys; print(len(json.load(open(sys.argv[1]))) )' "$INV/python-packages.json")" >> "$INV/summary.txt"
printf 'Global npm package entries: %s\n' "$(node -e 'const d=require(process.argv[1]); console.log(Object.keys(d.dependencies||{}).length)' "$INV/npm-global.json")" >> "$INV/summary.txt"
printf 'Local skill directories: %s\n' "$(wc -l < "$INV/skills.txt" | tr -d ' ')" >> "$INV/summary.txt"
printf 'Named cached plugins: %s\n' "$(grep -vc '^#\|^App-specific ' "$INV/plugins.txt" || true)" >> "$INV/summary.txt"
printf 'Installed PRoot containers: %s\n' "$(tr '\n' ' ' < "$DISTROS" | sed 's/[[:space:]]*$//')" >> "$INV/summary.txt"

cat <<'EOF'
Inventory refreshed. Generated files contain package metadata, SDK/container records, and cached extension names.
They do not read or copy credentials, project source, model weights, logs, or private account data.
EOF
