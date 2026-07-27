#!/usr/bin/env bash
# build-bundle.sh — vendor the AWS SDK for PHP and package this module as an installable release zip.
#
# Output: dist/tiger-sdk-aws-<sdk-version>.zip  (+ .sha256) and prints SDK_VERSION=<x.y.z> on stdout tail.
#   The zip is the COMPLETE module — module.json, Bootstrap.php, docs, and a fully-resolved vendor/ tree
#   (aws/aws-sdk-php + Guzzle + all transitive deps + the generated autoloader). It unzips into
#   application/modules/tiger-sdk-aws/ and runs with NO Composer on the target (the cPanel install case).
#
# We track UPSTREAM: `composer update` pulls the latest aws/aws-sdk-php ^3 and the release is tagged with
# that exact SDK version — one bundle per module, kept current (no version picker; latest is the version).
#
# Usage:  ./bin/build-bundle.sh            (CI or local; needs composer + zip)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="${OUT:-$ROOT/dist}"
cd "$ROOT"
for t in composer zip; do command -v "$t" >/dev/null || { echo "!! '$t' required"; exit 1; }; done

echo "Resolving the latest aws/aws-sdk-php ^3 …"
# Full update (aws/aws-sdk-php is the only direct require) — resolves the SDK + all deps to latest.
# A partial `update aws/aws-sdk-php` needs a pre-existing lock file; a full update builds one.
rm -f composer.lock
COMPOSER_MEMORY_LIMIT=-1 composer update \
    --no-dev --prefer-dist --optimize-autoloader --no-interaction --no-progress

# The exact SDK version we just vendored -> the release tag.
SDK_VERSION="$(composer show aws/aws-sdk-php 2>/dev/null | awk '/^versions/ {print $4}' | tr -d 'v*')"
[ -n "$SDK_VERSION" ] || { echo "!! could not determine aws-sdk-php version"; exit 1; }
echo "Vendored aws-sdk-php ${SDK_VERSION}"

# Assemble the module payload (everything the target needs, nothing it doesn't).
WORK="$(mktemp -d)"; trap 'rm -rf "$WORK"' EXIT
PKG="$WORK/tiger-sdk-aws"
mkdir -p "$PKG"
if command -v rsync >/dev/null; then
    rsync -a --exclude='.git' --exclude='.github' --exclude='dist' --exclude='.idea' \
          --exclude='composer.lock' ./ "$PKG"/
else
    cp -a ./ "$PKG"/ && rm -rf "$PKG/.git" "$PKG/.github" "$PKG/dist" "$PKG/.idea" "$PKG/composer.lock"
fi

# Stamp module.json version to the exact SDK version we vendored — so the installed module's version
# equals the release tag, which is what the Module Manager's update check compares against.
SDK_VERSION="$SDK_VERSION" php -r '
    $f = $argv[1];
    $m = json_decode(file_get_contents($f), true);
    $m["version"] = getenv("SDK_VERSION");
    file_put_contents($f, json_encode($m, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES) . "\n");
' "$PKG/module.json"

mkdir -p "$OUT"
ZIP="$OUT/tiger-sdk-aws-${SDK_VERSION}.zip"
rm -f "$ZIP" "$ZIP.sha256"
( cd "$WORK" && zip -qr "$ZIP" tiger-sdk-aws )
( cd "$OUT" && shasum -a 256 "$(basename "$ZIP")" > "$(basename "$ZIP").sha256" )

echo "Built $ZIP"
echo "SDK_VERSION=${SDK_VERSION}"
