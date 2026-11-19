# Current Termux inventory

Captured on **2026-11-19**. Package lists and the local SDK/container manifests are the detailed record; this page summarizes the system they describe.

## Device and Termux

| Item | Observed value |
| --- | --- |
| Manufacturer and model | Xiaomi 24129RT7CC |
| Android | 16 |
| Supported ABI | arm64-v8a only |
| Kernel | Linux 6.6.118, Android 15 kernel build |
| Termux app | 0.118.3, GitHub release |
| Termux build and package format | Debuggable build, apt/dpkg (`debian`) |
| termux-tools | 1.45.0 |
| Package architecture | aarch64 |
| Home | `/data/data/com.termux/files/home` |
| Prefix | `/data/data/com.termux/files/usr` |
| Installed Termux packages | 497, including dependencies |
| APT manual-marked packages | 389 |

Termux runs as an Android application user, not as root. The inventory covers Termux's private app directory and the shared-storage paths granted to it. It cannot enumerate other apps' private data or every Android application.

At capture time, Android's shared data volume showed **225 GB total, 194 GB used, and 30 GB available**. These numbers describe the shared device volume and can change independently of Termux.

## Package sources and updates

APT sources are recorded in [repositories.txt](../inventory/repositories.txt): Termux main, X11, glibc, and TUR. The complete installed package/version/architecture list is [packages.tsv](../inventory/packages.tsv); packages marked manual by APT are in [manual-packages.txt](../inventory/manual-packages.txt).

APT reported four updates available at capture time: `codex`, `fontconfig-utils`, `fontconfig`, and `libfontenc`. They are not included at their offered versions in the installed-package snapshot.

## Programming and build tools

| Area | Installed software observed |
| --- | --- |
| Shell and system tools | Bash 5.3.20, coreutils, Git 2.56.1, GitHub CLI 2.105.0, ripgrep, fd, jq 1.8.2, tmux, OpenSSH 10.6p2 |
| Python | Python 3.14.10; six Python packages are listed in [python-packages.json](../inventory/python-packages.json) |
| JavaScript | Node.js 26.13.1 and a separate Node.js 24 installation; npm 12.2.3; six global packages in [npm-global.json](../inventory/npm-global.json) |
| JVM | OpenJDK 17, 21, and 25 packages; default `java` reports 21.0.13.1; Kotlin 2.4.21; Gradle 9.9.1; Maven 3.10.1 |
| Native and systems languages | Clang/LLVM 21.1.8, CMake 4.5.0, Make 4.4.1, Rust 1.100.0, Go 1.27.4, Ruby 4.0.9, PHP 8.5.12, Perl |
| Android | Android command-line tools, platform-tools, build-tools, Android platform 37, NDK 27.1.12297006, AAPT/AAPT2, D8, apksigner, apktool, adb, and fastboot |
| Web and desktop | Chromium 157.0.8103.78, code-server 4.145.2, Xfce 4.20, Termux:X11 package 1.03.01-6 |
| Media and emulation | FFmpeg 9.0.2, DOSBox/DOSBox-X, and QEMU x86-64 user-mode emulation |
| Local services | Ollama 0.40.16, OpenSSH, and Termux API client package 0.60.0 |

Package presence records what is installed, not whether every command or workflow works. The Kotlin command-line probe emitted a Jansi native-library loading error. The Android SDK Manager emitted a warning that it only understands SDK XML through version 3 while it encountered version 4.

## Android SDK and NDK

SDK root: `$HOME/android-sdk` (about 2.7 GB). The SDK Manager recognized these installed components:

- `build-tools;36.0.0`
- `build-tools;37.0.0`
- `cmake;3.22.1`
- `ndk;27.1.12297006`
- `platform-tools` 37.0.1
- `platforms;android-37.0`

The SDK Manager's list and the `source.properties` files found on disk are recorded in [android-sdk.txt](../inventory/android-sdk.txt). The separate `$HOME/termux-ndk-27.1.12297006` compatibility tree (about 814 KB) links NDK metadata to Termux LLVM, headers, and libraries. Its observed symbolic links are in [ndk-symlinks.txt](../inventory/ndk-symlinks.txt).

## Linux containers

`proot-distro` has two installed containers:

| Container | Release | Recorded package count |
| --- | --- | ---: |
| Debian | Debian GNU/Linux 13.7 (trixie) | 1,297 |
| Alpine | Alpine Linux 3.24.3 | 326 |

See [containers.txt](../inventory/containers.txt), the [Debian package list](../inventory/debian-packages.tsv), the [Alpine package list](../inventory/alpine-packages.txt), and the OS release files for the full records. Fedora is not installed.

## Android storage access and Termux settings

Termux has shared-storage links under `$HOME/storage` for `shared`, `downloads`, `dcim`, `pictures`, `movies`, and `music`, pointing into `/storage/emulated/0`. The `termux-api` client package is installed; a compatible companion app and its permissions were not confirmed in this inventory.

The active Termux extra-key rows are:

```text
ESC / - HOME UP END PGUP
TAB CTRL ALT SHIFT LEFT DOWN RIGHT KEYBOARD
```

The remaining settings in `~/.termux/termux.properties` are comments/default examples. A safe copy of the active setting is in [termux.properties](../config/termux.properties).

## Services and local data

Startup scripts exist for SSH, Ollama, and an OpenCode server. An SSH daemon and an OpenCode server process were observed during the scan. The Ollama CLI is installed, but `ollama list` could not connect to a running server. Server addresses, passwords, SSH keys, authentication state, logs, and model files are not copied into this repository.

The device has local development projects, Android SDK data, package caches, assistant state, and model files. Their names and metadata are documented in the device-local `~/TERMUX-LOCAL-INVENTORY.md`, which is intentionally kept outside this repository. No file contents from those private areas were included in this report.

## Inventory scope

`bash scripts/refresh-inventory.sh` regenerates package lists, repository records, SDK metadata, and PRoot container package lists. It is read-only with respect to installed software and does not export credentials, project source, model weights, or logs. The inventory describes one point in time; running services, available updates, disk space, and repository versions can change later.
