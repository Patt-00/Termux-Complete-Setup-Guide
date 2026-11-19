# Termux setup inventory

Current environment snapshot captured **2026-11-19**. It records the Android and Termux versions, all installed Termux packages, language package lists, SDK components, Linux containers, and the major available toolchains.

## Read the documentation

1. [Current environment inventory](docs/current-inventory.md)
2. [Capabilities and installed tools](docs/capabilities.md)
3. [Recreate the setup](docs/recreate.md)
4. [React Native APK build notes](docs/react-native-apk.md)
5. [Limits and privacy](docs/limits.md)
6. [Private backup notes](docs/private-backup.md)

## Captured environment

| Item | Observed value |
| --- | --- |
| Android device | Xiaomi 24129RT7CC, Android 16, arm64-v8a |
| Kernel | Linux 6.6.118, Android 15 kernel build |
| Termux | 0.118.3, GitHub release, apt/dpkg, aarch64 |
| Installed Termux packages | 497, including dependencies |
| PRoot containers | Debian 13.7 and Alpine 3.24.3 |
| Android SDK | SDK Manager recognizes 6 packages; see inventory for exact IDs |
| NDK | 27.1.12297006 plus a local Termux compatibility tree |
| Main storage | 225 GB total, 30 GB available at capture time |

The inventory covers files visible to the Termux app and the shared-storage links it has. Android restricts access to other apps' private data. This snapshot does not claim to enumerate every Android app or the whole device.

## Complete package records

- [All 497 installed Termux packages](inventory/packages.tsv) and [389 APT manual-marked packages](inventory/manual-packages.txt).
- [APT repositories](inventory/repositories.txt), [Python packages](inventory/python-packages.json), and [global npm packages](inventory/npm-global.json).
- [Android SDK components](inventory/android-sdk.txt) and [custom NDK links](inventory/ndk-symlinks.txt).
- [Debian packages](inventory/debian-packages.tsv), [Alpine packages](inventory/alpine-packages.txt), and each container's OS release file.
- [Local skill names](inventory/skills.txt) and [cached plugin names](inventory/plugins.txt). A cache entry does not imply an account connection.
- [Inventory counts](inventory/summary.txt) and [capture timestamp](inventory/captured-at.txt).

Run `bash scripts/refresh-inventory.sh` in Termux to refresh these generated records. The script collects package metadata, repository URLs, SDK metadata, and container package lists. It does not copy credentials, project source, model weights, or logs.

The exact local project names, top-level files, and private app-data areas are documented separately in `~/TERMUX-LOCAL-INVENTORY.md` on the device. That file is intentionally outside this repository. This repository does not contain project source, account credentials, SSH keys, server passwords, personal logs, or model weights.

## Reinstalling packages

Review [packages.tsv](inventory/packages.tsv) first. The helper script supports current repository versions or exact recorded versions:

```sh
bash scripts/install-packages.sh names
bash scripts/install-packages.sh exact
```

APT will show the proposed transaction. Exact versions may no longer exist in configured repositories. Reinstalling packages does not restore Android settings, private configuration, container data, projects, local model weights, or account access.

## Sources

The local device metadata is the source for this snapshot. Upstream references: [Termux](https://github.com/termux/termux-app), [Termux:X11](https://github.com/termux/termux-x11), [Termux packages](https://github.com/termux/termux-packages), [glibc packages](https://github.com/termux/glibc-packages), [TUR](https://github.com/termux-user-repository/tur), and [Android SDK Manager](https://developer.android.com/tools/sdkmanager).
