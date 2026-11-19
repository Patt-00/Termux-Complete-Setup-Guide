# Limits, privacy, and troubleshooting

## What this inventory can see

Termux can inventory its own app data, installed Termux packages, the installed PRoot containers, and shared-storage locations Android has granted. It cannot enumerate other Android apps' private data. No root access was established.

The checked-in records contain package names and versions, repository URLs, SDK metadata, and container package lists. They exclude project source, model weights, SSH keys, account tokens, server passwords, private assistant history, and personal logs. The device-local appendix is outside this repository.

## Reproducibility limits

APT, npm, pip, Android SDK, Debian, and Alpine repositories change over time. An exact version may disappear, and a package being present does not prove that every command or app workflow runs correctly on this device. Android permissions, companion apps, account authorization, local configuration, model weights, projects, and active service settings need separate restoration.

The SDK Manager recognized six installed components, but emitted a warning about SDK XML version 4. The Kotlin command probe reported a Jansi native-library loading error. Ollama was installed but no server was running. No fresh-device restore, Android build, GUI launch, or model inference was performed as part of this inventory.

## Troubleshooting pointers

| Symptom | Check |
| --- | --- |
| Package or version unavailable | Review `inventory/repositories.txt`, run `pkg update`, then inspect `apt-cache policy NAME`. |
| `Exec format error` | Check the binary architecture with `file`; Android phones in this snapshot are ARM64. |
| `CANNOT LINK EXECUTABLE` | Check whether the program expects bionic or glibc and inspect inherited linker variables. |
| X11 window does not appear | Confirm the Android Termux:X11 companion is installed and open, then check display and desktop processes. |
| Android API client fails | Confirm the matching Termux:API Android companion is installed and has the needed permission. |
| APK build fails | Check the project-required JDK, SDK build-tools, NDK layout, and ARM64-compatible host tools. |
| Ollama command cannot connect | Start the local Ollama service and check whether the desired model has been registered. |
| Background service stopped | Review Termux:Boot configuration and Android battery/background restrictions. |

For a refreshed package and container snapshot, run `bash scripts/refresh-inventory.sh` from the repository in Termux.
