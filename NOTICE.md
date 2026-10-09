# NOTICE — Third-party components in Cordon's tunnel extension

## sing-box
- **Copyright:** SagerNet Inc.
- **License:** GNU GPL-3.0-or-later, plus the additional clause from the
  upstream LICENSE: "no derivative work may use the name or imply
  association with this application without prior consent."
- **Upstream:** https://github.com/SagerNet/sing-box
- **Pinned commit:** 6afeff4 (2026-10-09, "Bump version")
- **Binary:** Libbox.xcframework, built by `build/build-libbox.sh`;
  SHA-256 in `build/checksums.txt`.
- Modifications: none as of this notice. Any modifications will be
  published in this repository under GPL-3.0.

## Dependencies vendored inside Libbox
sing-box's Go dependencies (SagerNet forks of gomobile, quic-go, gvisor,
wireguard-go, tailscale, and others — see sing-box `go.mod` at the pinned
commit) are compiled into the framework. Their license obligations are
satisfied by the pinned, reproducible source build in this repository.

## CordonTunnel extension code
Copyright the Cordon authors. License: GPL-3.0-or-later.

## Not covered by this repository
The Cordon main application (UI, rule editor, onboarding, diagnostics) is a
separate process, distributed under a proprietary license, and communicates
with the extension exclusively through the standard NetworkExtension
provider-configuration mechanism (data, not linked code).
