#!/bin/sh
# Points the casks and the formula at the latest flockswitch and UsageMeter releases:
# version and sha256.
# Needs gh (GH_TOKEN) and sha256sum. Leaves the files unchanged when already current.
set -eu
cd "$(dirname "$0")/../.."
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# The version in the formula's x86_64 url.
linux_version() {
    grep -m1 -o 'flockswitch-linux-x86_64-[0-9.]*[0-9]' Formula/flockswitch.rb | sed 's/.*-//'
}

latest() {
    gh release view --repo "WWhaleFe/$1" --json tagName --jq '.tagName | ltrimstr("v")'
}

# macOS: one zip.
v=$(latest flockswitch-mac)
zip="flockswitch-macos-arm64-$v.zip"
gh release download "v$v" --repo WWhaleFe/flockswitch-mac --pattern "$zip" --dir "$tmp"
sum=$(sha256sum "$tmp/$zip" | cut -d' ' -f1)
sed -i -e "s/^  version \".*\"/  version \"$v\"/" \
       -e "s/^  sha256 \".*\"/  sha256 \"$sum\"/" Casks/flockswitch.rb

# Linux: the release's SHA256SUMS.txt covers both tarballs. The formula's urls spell out
# the version (Homebrew reads it from them).
v=$(latest flockswitch-linux)
old=$(linux_version)
gh release download "v$v" --repo WWhaleFe/flockswitch-linux --pattern SHA256SUMS.txt --dir "$tmp"
for arch in x86_64 aarch64; do
    sum=$(grep "flockswitch-linux-$arch-$v.tar.gz" "$tmp/SHA256SUMS.txt" | cut -d' ' -f1)
    [ -n "$sum" ] || { echo "no checksum for $arch $v"; exit 1; }
    # The sha256 line right after this arch's url line.
    sed -i "/flockswitch-linux-$arch-/{n;s/sha256 \".*\"/sha256 \"$sum\"/;}" Formula/flockswitch.rb
done
sed -i "/^      url /s/$(echo "$old" | sed 's/\./\\./g')/$v/g" Formula/flockswitch.rb

# UsageMeter (macOS, universal): one zip per release.
v=$(latest usagemeter)
zip="UsageMeter-v$v.zip"
gh release download "v$v" --repo WWhaleFe/usagemeter --pattern "$zip" --dir "$tmp"
sum=$(sha256sum "$tmp/$zip" | cut -d' ' -f1)
sed -i -e "s/^  version \".*\"/  version \"$v\"/" \
       -e "s/^  sha256 \".*\"/  sha256 \"$sum\"/" Casks/usagemeter.rb

git diff --stat
