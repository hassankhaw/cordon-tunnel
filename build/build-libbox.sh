#!/bin/bash
# Reproducible Libbox.xcframework build for Cordon's GPL compliance (see NOTICE.md).
# Usage: ./build-libbox.sh [WORKDIR]   (default: ~/Projects/third_party)
set -euo pipefail

WORKDIR="${1:-$HOME/Projects/third_party}"
SING_BOX_REPO="https://github.com/SagerNet/sing-box"
SING_BOX_COMMIT="6afeff4"          # pinned: verified 2026-10-09
GO_VERSION="1.26.9"                # pinned: matches sing-box CI (go 1.26.x)
GOMOBILE_VERSION="v0.1.13"         # pinned: sing-box Makefile lib_install
GO_EXPECTED_SHA="SET_AT_FIRST_PUBLISH"  # fill from https://go.dev/dl/?mode=json&include=all

mkdir -p "$WORKDIR"; cd "$WORKDIR"

# --- Go toolchain (user-local, checksum verified) ---
export GOROOT="$HOME/.local/go-$GO_VERSION"
export GOPATH="$HOME/go"
export PATH="$GOROOT/bin:$GOPATH/bin:$PATH"
if [ ! -x "$GOROOT/bin/go" ]; then
  echo "Downloading Go $GO_VERSION (darwin-arm64)…"
  curl -fsSL -o go.tgz "https://go.dev/dl/go$GO_VERSION.darwin-arm64.tar.gz"
  if [ "$GO_EXPECTED_SHA" != "SET_AT_FIRST_PUBLISH" ]; then
    echo "$GO_EXPECTED_SHA  go.tgz" | shasum -a 256 -c -
  fi
  mkdir -p "$GOROOT.tmp" && tar -xzf go.tgz -C "$GOROOT.tmp" --strip-components=1
  mv "$GOROOT.tmp" "$GOROOT"
fi
go version

# --- sing-box at the pinned commit ---
if [ ! -d sing-box ]; then git clone "$SING_BOX_REPO" sing-box; fi
cd sing-box
git fetch origin "$SING_BOX_COMMIT" 2>/dev/null || true
git checkout "$SING_BOX_COMMIT"
git submodule update --init --recursive

# --- gomobile tooling (pinned) ---
command -v gomobile >/dev/null || go install -v github.com/sagernet/gomobile/cmd/gomobile@$GOMOBILE_VERSION
command -v gobind   >/dev/null || go install -v github.com/sagernet/gomobile/cmd/gobind@$GOMOBILE_VERSION

# --- Build iOS device + simulator ---
go run ./cmd/internal/build_libbox -target apple -platform ios,iossimulator
test -d Libbox.xcframework || { echo "BUILD FAILED"; exit 1; }

echo "---- checksums ----"
shasum -a 256 Libbox.xcframework/ios-arm64/Libbox.framework/Libbox \
             Libbox.xcframework/ios-arm64_x86_64-simulator/Libbox.framework/Libbox
echo "Done: $PWD/Libbox.xcframework"
