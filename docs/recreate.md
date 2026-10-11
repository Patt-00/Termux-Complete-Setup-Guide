# Recreate the environment

Target a **fresh ARM64 Termux installation**. Back up existing environments first. A fresh-device restoration was not executed during this inventory.

## 1. Install Android apps

Install [Termux 0.118.3 from GitHub](https://github.com/termux/termux-app/releases/tag/v0.118.3) and open it to initialize its files. Install the ARM64 [Termux:X11 companion APK](https://github.com/termux/termux-x11/releases/tag/nightly). Captured X11 versionCode 15 does not uniquely identify a nightly build.

Plugins that share Termux's app identity must match its signing source. Follow [Termux installation instructions](https://github.com/termux/termux-app#installation). Install Shizuku separately for Android shell integration.

```sh
termux-setup-storage
pkg update
pkg install git gh python
git clone https://github.com/Patt-00/Termux-Complete-Setup-Guide.git
cd Termux-Complete-Setup-Guide
```

## 2. Enable repositories

```sh
pkg install x11-repo tur-repo
pkg update
```

All observed URLs are in [repositories.txt](../inventory/repositories.txt). The glibc source was:

```text
deb https://packages-cf.termux.dev/apt/termux-glibc/ glibc stable
```

Follow [upstream glibc installation guidance](https://github.com/termux/glibc-packages) to configure the supported repository and signing keys. Its documented entrypoint is `pkg install glibc-repo`; availability depends on sources. If unavailable, consult upstream rather than disabling signature checking. The original device has the glibc source file but no installed `glibc-repo` package record.

Main/X11 use the Nevacloud mirror. `termux-change-repo` can select another official mirror if necessary.

## 3. Install captured packages

Read [packages.tsv](../inventory/packages.tsv) before proceeding. With every source configured:

```sh
# Currently available versions of all recorded installed package names:
bash scripts/install-packages.sh names
# Alternative: precisely recorded versions, if still available:
bash scripts/install-packages.sh exact
```

Apt displays its proposed transaction for confirmation. The script stops on failure; exact mode does not silently substitute versions. Package conflicts, missing repositories or removed versions need manual resolution. The list includes dependencies; replaying it marks the requested packages manual. Original classification is preserved in `manual-packages.txt`.

For a smaller starting environment:

```sh
pkg install bash git gh ripgrep jq tmux vim micro nodejs python python-pip \
  python-numpy python-scipy python-lxml openjdk-21 clang cmake ninja make \
  termux-x11-nightly openbox chromium code-server pulseaudio
```

## 4. Python, npm and assistant tooling

Keep NumPy, SciPy, lxml, pip and proot-distro managed by Termux packages. The pip inventory includes apt-owned packages; do not indiscriminately replay it through pip.

```sh
python -m pip install certifi==2026.7.22 charset-normalizer==3.5.1 \
  click==8.5.0 idna==3.19 nextdnsctl==1.3.0 Pygments==2.21.0 \
  pyparsing==3.3.2 pypdf==6.19.0 rdflib==7.6.0 \
  requests==2.34.2 urllib3==2.7.0
npm install -g @mmmbuto/codex-cli-termux@0.160.0-termux.2
```

Pins record the source installation; external registries may not retain them. The Codex package is a community Termux adaptation; follow [its installation documentation](https://github.com/DioNanos/codex-termux), and authenticate with your own account. Selected options, skill names and plugin names are recorded in `inventory/`. The account's separate `codex-skills` repository may supply reusable skill sources. Install/connect plugins separately; cached tools do not transfer permissions or service access.

Node 24 is separately installed under `$PREFIX/opt/nodejs-24`; default `node` may use Node 26. npm 11.19.1 is recorded globally, but its base installation should remain managed by the Termux npm package.

## 5. Shell, desktop and IDE

Read `config/bashrc.fragment`, then add it to your shell configuration once. It defines SDK paths and `$HOME/bin`. The captured Termux properties have no active overrides.

```sh
mkdir -p "$HOME/bin" "$HOME/.config/code-server"
cp launchers/chrome launchers/ide "$HOME/bin/"
chmod 700 "$HOME/bin/chrome" "$HOME/bin/ide"
```

Create `$HOME/.config/code-server/config.yaml` with your own password:

```yaml
bind-addr: 127.0.0.1:8080
auth: password
password: REPLACE_WITH_YOUR_OWN_STRONG_PASSWORD
cert: false
```

This example is not a copy of the original credential file. Open the Termux:X11 Android companion. Start `termux-x11 :0`; in another terminal run `DISPLAY=:0 dbus-launch --exit-with-session openbox`. Then use `chrome` or `ide "$HOME/projects"` from a terminal with the shell paths loaded. The custom launcher starts X11/Openbox/PulseAudio as needed and tries rish to open the companion if configured.

The browser uses scale 1.5, a 1707×1139 window hint, four renderer processes and 100 MB disk cache. Adjust display settings for your hardware. It uses `--no-sandbox`, which weakens Chromium's normal isolation. The IDE config above binds to loopback and uses your password. The IDE launcher stores process/log state in `.local/state/tablet-ide`.

`config/Xresources.observed` contains an original malformed line joining two font settings. A clean configuration uses `XTerm*faceName: Monospace` and `XTerm*faceSize: 24` on separate lines; load using `xrdb -merge ~/.Xresources`.

## 6. Android SDK and NDK

Set `ANDROID_HOME` and `ANDROID_SDK_ROOT` to `$HOME/android-sdk`. Captured components include command-line tools revision 22.0; platforms 33/36/37; build-tools 35/36/37; CMake 3.22.1 and NDK 27.1.12297006. See [exact metadata](../inventory/android-sdk.txt).

Download official command-line tools following [Google SDK Manager guidance](https://developer.android.com/tools/sdkmanager), extract to `android-sdk/cmdline-tools/latest`, and accept licenses yourself. When those components are available:

```sh
sdkmanager --sdk_root="$ANDROID_HOME" \
  'platform-tools' 'platforms;android-33' 'platforms;android-36' \
  'platforms;android-37' 'build-tools;35.0.0' 'build-tools;36.0.0' \
  'build-tools;37.0.0' 'cmake;3.22.1' 'ndk;27.1.12297006'
```

Downloaded Linux executables may be x86_64. Use Termux's android-tools, AAPT2, d8, LLVM and CMake where supported. Downloading SDK components alone does not make their host executables run on ARM64.

`$HOME/termux-ndk` is a custom compatibility tree. [Its symlink manifest](../inventory/ndk-symlinks.txt) links Google NDK metadata/toolchain files to Termux LLVM, includes, runtime and sysroot libraries. It also contains real files beyond links; the manifest alone does not recreate the whole tree. Preserve it privately for an exact copy, or adapt a tree using [the React Native APK guide](react-native-apk.md). Captured links reference Clang major 21 and Android API 24; validate these against installed files.

## 7. Debian, Fedora and JavaFX

```sh
proot-distro install debian
proot-distro install fedora
proot-distro login debian
```

Fresh PRoot installations may select newer releases. Captured distribution IDs are in `inventory/*-os-release.txt`. Debian package versions are in `inventory/debian-packages.tsv`. Fedora's complete RPM inventory was not exported; exact restoration requires its private backup.

For JavaFX, install JDK 21, Maven and GTK/X11 dependencies inside Debian. Use that release's supported repositories or a supported JDK source if JDK 21 is unavailable. The project-specific launcher uses `proot-distro login --shared-tmp debian`, `DISPLAY=:0` and JavaFX 22.0.2 Linux ARM64 jars. Restore the project separately. Native Termux OpenJDK does not supply Linux JavaFX libraries inside Debian.

## 8. Shizuku and Android API access

Follow Shizuku's **Use Shizuku in terminal apps** instructions. Export `rish` and `rish_shizuku.dex` to `$HOME/bin`, configure `RISH_APPLICATION_ID=com.termux`, start Shizuku and authorize Termux.

```sh
chmod 700 "$HOME/bin/rish"
chmod 400 "$HOME/bin/rish_shizuku.dex"
rish -c id
```

The original wrapper enforces read-only DEX permissions for Android 14+. The DEX is not distributed here. The termux-api clients are installed, but the Android companion was not detected. Install a source-compatible companion and grant permissions for API features you need.

## 9. Models, emulation and remote access

Ollama has a local `humanizer-no-thinking-2` manifest. Its source Modelfile references a separately stored Q4_K_M GGUF, context 1024 and batch 64. A Q2_K GGUF also exists. Weights and their origin/license provenance are not included. Restore your permitted model files, create your own Modelfile, then:

```sh
ollama serve
# Another terminal:
ollama create humanizer-no-thinking-2 -f Modelfile
ollama run humanizer-no-thinking-2
```

A local Ollama library backup suggests earlier manual adjustments. Their exact binary differences were not established. Private backup preserves them; a package reinstall may not.

DOSBox/DOSBox-X and QEMU userspace are installed; supply your own permitted application/game data. QEMU userspace is not a complete Android emulator. SSH/VNC packages are present, but keys, passwords, active listeners and server configuration were not exported. Configure them explicitly.

## 10. Compare after restoration

```sh
termux-info
dpkg-query -W -f='${Package}\t${Version}\n'
python -m pip list
npm list -g --depth=0
proot-distro list
```

Compare output to the captured inventory. No fresh installation, build, GUI launch or inference run was performed while documenting this setup.
