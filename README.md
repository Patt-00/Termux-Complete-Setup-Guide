# My complete Termux setup

Inventory and recreation guide for Patt-00's ARM64 Android development environment, captured **2026-10-11**. **446 installed Termux packages**, Python and npm packages, Debian/Fedora containers, Android SDK/NDK, desktop tools and local AI are documented.

## Read the guide

1. [Capabilities and usage](docs/capabilities.md)
2. [Recreate this setup](docs/recreate.md)
3. [Android and React Native APK builds](docs/react-native-apk.md)
4. [Exact restoration through private backup](docs/private-backup.md)
5. [Limits and troubleshooting](docs/limits.md)

## Captured environment

| Item | Observed value |
| --- | --- |
| Termux | 0.118.3, GitHub build; apt/debian packages |
| Architecture | aarch64 / arm64-v8a; no Android 32-bit ABI reported |
| Android / hardware | Android 16, Xiaomi 2410CRP4CG |
| Kernel | Linux 6.1.138, Android 14 kernel branch |
| Home | `/data/data/com.termux/files/home` |
| Prefix | `/data/data/com.termux/files/usr` |
| Repositories | main, X11, TUR, glibc |
| Detected companion | Termux:X11 versionCode 15 |
| Linux containers | Debian and Fedora |
| SDK / model storage | approximately 3.1 GiB SDK and 9.2 GiB Ollama data |

Installed software establishes available building blocks; it does not prove every workflow currently works. This public repository is a documentation snapshot. An exact copy also requires privately preserved files, available package versions, model weights, projects, Android settings and your own account access.

## Inventory and supporting files

- [Every dpkg package/version/architecture/status](inventory/packages.tsv), including dependencies.
- [Originally manual packages](inventory/manual-packages.txt).
- [Python packages](inventory/python-packages.json) and [global npm packages](inventory/npm-global.json).
- [Debian packages](inventory/debian-packages.tsv) and container OS release files.
- [Repository URLs](inventory/repositories.txt), [SDK revisions](inventory/android-sdk.txt), [custom NDK symlinks](inventory/ndk-symlinks.txt).
- Local skill/plugin names and selected non-secret Codex options in `inventory/`.
- Reviewed `chrome` and `ide` launchers in `launchers/`, safe shell setup in `config/`.
- `scripts/install-packages.sh`: install names or attempt exact versions.

## Sources

Local device metadata is the primary source for the captured installation. Installation references: [Termux](https://github.com/termux/termux-app), [Termux:X11](https://github.com/termux/termux-x11), [Termux packages](https://github.com/termux/termux-packages), [glibc repository](https://github.com/termux/glibc-packages), [TUR](https://github.com/termux-user-repository/tur), [SDK Manager](https://developer.android.com/tools/sdkmanager), [Shizuku rish](https://github.com/RikkaApps/Shizuku-API/tree/master/rish), [community Termux Codex build](https://github.com/DioNanos/codex-termux).
