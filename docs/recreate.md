# Recreate the Termux setup

This guide describes the environment captured on 2026-11-19. A fresh-device restoration was not attempted. Use the inventory as a reference and review every proposed package transaction before accepting it.

## 1. Install Termux and grant shared storage

Install Termux from the same signing source as any Termux companion apps you use. The captured app was Termux 0.118.3 from GitHub. Then initialize shared-storage access:

```sh
termux-setup-storage
pkg update
pkg install git python
git clone https://github.com/Patt-00/Termux-Complete-Setup-Guide.git
cd Termux-Complete-Setup-Guide
```

The captured Termux:X11 package is listed in [packages.tsv](../inventory/packages.tsv). The matching Android companion is installed separately; this inventory did not confirm its presence.

## 2. Configure package repositories

The captured sources are listed in [repositories.txt](../inventory/repositories.txt): Termux main, X11, glibc, and TUR. Install the repository packages where available, then refresh metadata:

```sh
pkg install x11-repo tur-repo
pkg update
```

For glibc, follow the current [upstream installation guidance](https://github.com/termux/glibc-packages). Do not disable package signature checking to work around a repository setup problem.

## 3. Install the recorded Termux packages

The [full package manifest](../inventory/packages.tsv) contains 497 packages, including dependencies. The included helper offers two modes:

```sh
# Install the package names at versions currently available from configured repos.
bash scripts/install-packages.sh names

# Request the versions captured in the manifest, if still available.
bash scripts/install-packages.sh exact
```

APT will show the proposed transaction. The exact versions may no longer be available. Replaying every package also marks the requested packages manual; the original manual selection is recorded in [manual-packages.txt](../inventory/manual-packages.txt).

## 4. Restore language packages

The installed Python packages are recorded in [python-packages.json](../inventory/python-packages.json); globally installed npm packages are in [npm-global.json](../inventory/npm-global.json). Read those manifests before installing anything. Some Python packages are owned by Termux's package manager, so do not replay the entire Python list through pip. Registry packages and exact versions can change.

The captured default Node.js was 26.13.1 with npm 12.2.3. Node.js 24.22.3 was installed separately under `$PREFIX/opt/nodejs-24`.

## 5. Configure Android development tools

The captured SDK root is `$HOME/android-sdk`. The SDK Manager recognized build-tools 36.0.0 and 37.0.0, CMake 3.22.1, NDK 27.1.12297006, platform-tools 37.0.1, and Android platform 37. The complete output and on-disk `source.properties` metadata are in [android-sdk.txt](../inventory/android-sdk.txt).

Google's downloaded host tools may target x86-64. On this ARM64 device, use Termux-compatible tools where available and follow the [React Native APK notes](react-native-apk.md) for the NDK compatibility approach. The captured compatibility tree is `$HOME/termux-ndk-27.1.12297006`; its symbolic links point to the installed Termux LLVM toolchain and libraries. It contains other files too, so the link manifest alone does not recreate the tree.

## 6. Restore Linux containers

The captured PRoot containers were Debian 13.7 and Alpine 3.24.3. Their full package lists are in [debian-packages.tsv](../inventory/debian-packages.tsv) and [alpine-packages.txt](../inventory/alpine-packages.txt). Fedora was not installed.

```sh
proot-distro install debian
proot-distro install alpine
proot-distro login debian
```

New container installs may select newer releases. Package inventories describe the original snapshot; they are not a guarantee that every package version can still be fetched.

## 7. Restore desktop and local services

The package list includes Xfce, Termux:X11, Chromium, code-server, OpenSSH, Ollama, and Termux API clients. Android companion apps, service credentials, and private service configuration are not included here. Set your own passwords and addresses locally. Check Android battery settings if background services stop.

Boot scripts for SSH, Ollama, and OpenCode were present during the inventory. A running SSH daemon and OpenCode server process were observed; their connection details and credentials are intentionally omitted.

## 8. Keep private data separate

This repository does not include project source, personal assistant history, SSH keys, passwords, account tokens, logs, or model weights. The device-local appendix at `~/TERMUX-LOCAL-INVENTORY.md` records local workspace and data metadata. Preserve private data through your own encrypted backup process.

## 9. Refresh and compare

After setup, regenerate package metadata and compare it with the snapshot:

```sh
bash scripts/refresh-inventory.sh
termux-info
dpkg-query -W -f='${binary:Package}\t${Version}\t${Architecture}\n'
python -m pip list
npm ls -g --depth=0
proot-distro list
```

The refresh script reads package databases and metadata. It does not install or remove packages and does not copy credentials, project source, logs, or model weights.
