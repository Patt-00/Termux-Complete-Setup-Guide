#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
mode="${1:-names}"
case "$mode" in names|exact) ;; *) echo 'Usage: bash scripts/install-packages.sh [names|exact]' >&2; exit 2;; esac
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
[[ "$(dpkg --print-architecture)" == aarch64 ]] || { echo 'Requires aarch64 Termux.' >&2; exit 1; }
mapfile -t requested < <(awk -F '\t' -v mode="$mode" '$4 == "installed" {if(mode == "exact") print $1 "=" $2; else print $1}' "$root/inventory/packages.tsv")
echo "Requesting ${#requested[@]} packages in $mode mode. Review apt changes before accepting."
apt install "${requested[@]}"
