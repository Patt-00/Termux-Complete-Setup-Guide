# Installed capabilities

This page summarizes installed software captured on 2026-11-19. See the [current inventory](current-inventory.md) for versions and the full package manifests.

| Capability | Installed evidence |
| --- | --- |
| Shell and source control | Bash, Git, GitHub CLI, ripgrep, fd, jq, tmux, and nano |
| Web development | Node.js 26 and 24, npm, TypeScript, Chromium, code-server |
| Python | Python 3.14, pip, and the packages listed in the Python manifest |
| JVM development | OpenJDK 17/21/25, Kotlin, Gradle, Maven |
| Native development | Clang/LLVM, CMake, Make, Rust, Go, Ruby, PHP, Perl |
| Android builds and device tools | Android SDK, NDK, AAPT/AAPT2, D8, apksigner, apktool, adb, fastboot |
| Graphical desktop | Termux:X11 package, Xfce 4.20, GTK and desktop libraries |
| Linux userspaces | Debian 13 and Alpine 3.24 through PRoot; glibc packages are also installed in Termux |
| Emulation | DOSBox, DOSBox-X, and QEMU x86-64 user-mode emulation |
| Media processing | FFmpeg and audio, image, and video libraries |
| Local services | OpenSSH, Ollama, code-server, and Termux API command-line clients |

## Example commands

```sh
python --version
node --version
java -version
clang --version
rustc --version
go version
ffmpeg -version
adb version
proot-distro login debian
proot-distro login alpine
```

Installed packages do not prove a full workflow works. The SDK Manager reported an XML-version warning, the Kotlin launcher emitted a Jansi native-library error during inspection, and Ollama had no server running at capture time. A compatible Termux:X11 Android companion and Termux:API companion were not confirmed.
