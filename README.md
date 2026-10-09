# cordon-tunnel

GPL-3.0 source for the **CordonTunnel** packet-tunnel extension of
[Cordon](https://github.com/hassankhaw/cordon) — a rule-based proxy utility for
iPhone and iPad. This repository exists to satisfy the obligations of the
GNU General Public License, Version 3, for the GPL-covered components Cordon
distributes (see `NOTICE.md`).

## What is covered

The CordonTunnel extension (the NetworkExtension packet-tunnel provider that
embeds the [sing-box](https://github.com/SagerNet/sing-box) engine via
`Libbox.xcframework`) is GPL-3.0. The Cordon main application is a separate
process that communicates with the extension through standard system
interfaces and is **not** covered by this repository.

## Reproducing the engine

`build/build-libbox.sh` reproduces `Libbox.xcframework` byte-for-byte
equivalently from source. It pins every input:

| Input | Version / commit |
|---|---|
| sing-box | `6afeff4` (verified 2026-10-09) |
| Go toolchain | 1.26.9 (darwin-arm64, checksum-verified download) |
| SagerNet gomobile / gobind | v0.1.13 (pinned by sing-box Makefile) |

`build/checksums.txt` contains the SHA-256 of the framework binaries this
recipe produced on Apple Silicon (macOS 26, Xcode 27).

```bash
./build/build-libbox.sh ~/Projects/third_party
```

## License

This code is licensed GPL-3.0-or-later (see `LICENSE`). sing-box is
Copyright SagerNet Inc. and licensed GPL-3.0 with an additional name-attribution
clause; we do not use the sing-box name or branding in Cordon's marketing, and
we ship factual attribution in the app's Acknowledgements screen.
