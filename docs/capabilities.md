# Capabilities of this installation

Evidence comes from package databases, installed directories, and inspected scripts. These are usage examples; no applications were launched during this audit.

| Capability | Installed evidence | Purpose |
| --- | --- | --- |
| Shell automation | Bash, coreutils, jq, ripgrep, fd, tmux | Scripts, file search, JSON and terminal sessions |
| GitHub work | git, gh, authenticated account | Clone, commit, push and manage repositories |
| Editing | Vim, nano, micro | Edit text and source |
| Browser IDE | code-server 4.141.0; custom `ide` | VS Code interface on localhost:8080 |
| Graphical desktop | Termux:X11, Openbox, GTK3, Qt6, X tools | Native GUI applications on Android |
| Desktop browser | Chromium 149.0.7827.155; `chrome` | Web browsing and browser development tools |
| Java/Kotlin | OpenJDK 17/21/25, Kotlin, Gradle, Maven | JVM programs and Android builds |
| JavaFX | Debian container and project-specific launcher | Linux ARM64 JavaFX through X11 |
| Web development | Node 26 plus separate Node 24, npm | React/Node and project TypeScript tooling |
| Python/science | Python 3.14.6, NumPy, SciPy, lxml, requests, pypdf, rdflib | Numerical work, HTTP, XML/PDF/RDF processing |
| Native languages | Clang/LLVM 21, Rust, Go, make, CMake, Ninja | Compile C/C++, Rust and Go |
| Scripting | Perl and Lua 5.4 | Scripts and language tools |
| Android APK builds | SDK, adapted NDK r27b, aapt/aapt2, d8, apksigner | Compile, package and sign Android apps |
| React Native CLI | Existing APK build documentation, QEMU workaround | Native ARM64 Android builds with project adjustments |
| APK inspection | apktool, jadx, unzip | Inspect APK resources and DEX |
| Android bridge | android-tools; rish wrapper | ADB and authorized Shizuku shell operations |
| Local AI | Ollama 0.31.1 and custom model manifest | Local inference subject to memory/compatibility |
| Coding assistant | @mmmbuto/codex-cli-termux 0.160.0-termux.2 | Community Termux Codex CLI; requires account access |
| Connected tools | Cached Figma, Drive, Sites, work-pets and other plugins | Requires separate service connections; cache does not prove authorization |
| Linux environments | proot-distro 5.9.0; Debian and Fedora | Linux userspace without a full VM |
| glibc compatibility | glibc, glibc-runner, glibc-suffixed packages | Selected Linux binaries in a separate prefix |
| DOS/x86 | DOSBox, DOSBox-X, NASM, QEMU i386/x86-64 | DOS applications and x86 userspace emulation |
| Multimedia | FFmpeg and audio/image/video libraries | Convert, encode and inspect media |
| Audio | PulseAudio, PipeWire, ALSA libraries | Audio for compatible clients |
| Remote access | OpenSSH, SFTP server, TigerVNC | Authorized remote terminal/file/GUI access |
| Networking | curl, wget, inetutils, net-tools | HTTP/downloads and network inspection |
| Android API clients | termux-api package | Matching Android companion and permissions needed; companion not detected |
| DNS administration | nextdnsctl Python package | Separately configured NextDNS access |

## Example commands

```sh
ide "$HOME/projects"
ide status
ide stop
chrome https://github.com
python --version
node --version
javac Example.java
java Example
clang hello.c -o hello
./hello
cargo --version
go version
ffmpeg -i input.mp4 output.webm
apksigner verify app.apk
proot-distro login debian
proot-distro login fedora
ollama serve
# From a second terminal after model restoration:
ollama run humanizer-no-thinking-2
```

`run-java` and `run-javafx` in `$HOME/bin` forward to `AdaptiveReadingGame`. They depend on that project and are not generic installed packages. The Java script deletes/recreates a compilation `bin` directory; inspect it before reusing it. The JavaFX launcher requires Debian JDK 21/Maven and JavaFX 22.0.2 ARM64 Linux jars. Project files and these project-bound scripts are excluded from publication.

Root access was not established. Shizuku and PRoot do not imply unrestricted root privileges. GPU acceleration, camera/microphone access, emulator compatibility and local model performance depend on further configuration.
