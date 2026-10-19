#!/bin/sh
set -eu

variant=big-eyes
force=false
variant_seen=false
for arg in "$@"; do
  case "$arg" in
    big-eyes|smirk)
      if [ "$variant_seen" = true ]; then
        printf 'Choose one edition: big-eyes or smirk.\n' >&2
        exit 2
      fi
      variant=$arg
      variant_seen=true
      ;;
    --force) force=true ;;
    -h|--help)
      printf 'Usage: %s [big-eyes|smirk] [--force]\n' "$0"
      exit 0
      ;;
    *) printf 'Unknown argument: %s\n' "$arg" >&2; exit 2 ;;
  esac
done

source_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
if [ "$variant" = smirk ]; then
  source_dir="$source_dir/variants/smirk"
fi
destination="${CODEX_HOME:-$HOME/.codex}/pets/anya-$variant"

for filename in pet.json spritesheet.png; do
  if [ ! -f "$source_dir/$filename" ]; then
    printf 'Missing package file: %s\n' "$source_dir/$filename" >&2
    exit 1
  fi
done
if [ -e "$destination" ] && [ "$force" != true ]; then
  printf 'Already exists: %s\nUse --force to replace its pet files.\n' "$destination" >&2
  exit 1
fi

mkdir -p "$destination"
cp "$source_dir/pet.json" "$source_dir/spritesheet.png" "$destination/"
printf 'Installed Anya (%s) in %s\nRefresh Settings > Pets and select Anya.\n' "$variant" "$destination"
