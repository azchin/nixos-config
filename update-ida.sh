#!/usr/bin/env bash
# Point modules/ida.nix at a freshly downloaded IDA installer.
#
#   ./update-ida.sh ~/Downloads/ida-classroom-free_94_x64linux.run
#
# requireFile looks the installer up by `name` + `sha256`, so a new runfile
# needs the store add and all three fields in ida.nix kept in sync. Hex-Rays
# re-publishes builds under the same filename, so the hash can change without
# the version doing so. Version is read off the filename (`_94_` -> 9.4); pass
# it explicitly to override.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IDA_NIX="$SCRIPT_DIR/modules/ida.nix"

DRY_RUN=no
if [ "${1:-}" = "--dry-run" ] || [ "${1:-}" = "-n" ]; then
  DRY_RUN=yes
  shift 1
fi

RUNFILE="${1:-}"
if [ -z "$RUNFILE" ]; then
  echo "usage: $0 [--dry-run] <path-to-runfile> [version]" >&2
  exit 1
fi
if [ ! -f "$RUNFILE" ]; then
  echo "no such file: $RUNFILE" >&2
  exit 1
fi
if [ ! -f "$IDA_NIX" ]; then
  echo "cannot find $IDA_NIX" >&2
  exit 1
fi

# A truncated or error-page "download" is the likeliest way this goes wrong,
# and the installer is a plain ELF binary -- cheap to rule out up front.
if [ "$(head -c 4 "$RUNFILE" | od -An -tx1 | tr -d ' \n')" != "7f454c46" ]; then
  echo "$RUNFILE is not an ELF executable -- bad or partial download?" >&2
  exit 1
fi

NAME="$(basename "$RUNFILE")"

VERSION="${2:-}"
if [ -z "$VERSION" ]; then
  # ida-classroom-free_94_x64linux.run -> 94 -> 9.4 (and 100 -> 10.0)
  digits="$(printf '%s' "$NAME" | grep -oP '_\K[0-9]+(?=_)' | head -1 || :)"
  if [ -z "$digits" ] || [ "${#digits}" -lt 2 ]; then
    echo "cannot read a version out of '$NAME' -- pass one: $0 $RUNFILE 9.4" >&2
    exit 1
  fi
  VERSION="${digits%?}.${digits: -1}"
fi

echo "Hashing $NAME (this takes a moment -- it is ~500MB)..."
SHA256="$(nix hash file --type sha256 --base16 "$RUNFILE")"

echo ""
echo "name    = \"$NAME\""
echo "version = \"$VERSION\""
echo "sha256  = \"$SHA256\""
echo ""

if [ "$DRY_RUN" = yes ]; then
  echo "--dry-run: leaving the store and $IDA_NIX untouched."
  exit 0
fi

echo "Adding to the store..."
STORE_PATH="$(nix-store --add-fixed sha256 "$RUNFILE")"
echo "$STORE_PATH"

# requireFile finds the installer by `name` + `sha256`, so all three fields
# have to land. Each pattern must hit exactly one line: a miss would leave
# ida.nix half-updated and the mismatch would only surface at build time.
replace() {
  local what="$1" pattern="$2" replacement="$3" hits
  hits="$(grep -cE "$pattern" "$IDA_NIX" || :)"
  if [ "$hits" != "1" ]; then
    echo "expected 1 $what line in $IDA_NIX, found $hits -- update this script" >&2
    exit 1
  fi
  sed -i -E "s|$pattern|$replacement|" "$IDA_NIX"
}

echo "Updating $IDA_NIX..."
replace name    'name = "[^"]*\.run";'       "name = \"$NAME\";"
replace version 'version = "[^"]*";'         "version = \"$VERSION\";"
replace sha256  'sha256 = "[0-9a-f]*";'      "sha256 = \"$SHA256\";"

echo ""
echo "Done. The installer now lives in the store, so $RUNFILE can be deleted."
echo "Next: ./rebuild.sh"
