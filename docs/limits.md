# Limits, privacy and troubleshooting

Public files include curated documentation, package metadata, safe configuration and inspected browser/IDE launchers. They exclude private projects, assistant sessions, auth files, SSH keys, keystores, browser profiles, NextDNS/cloud configuration, model weights, APKs, Android app data and backups. Tool/plugin names do not transfer account authorization.

Exact package versions may disappear from repositories. Containers, account access, manual binary patches, display settings and Android permissions are not fully reproducible from manifests. Fedora RPM versions were not enumerated. No fresh-device restore was attempted.

| Symptom | Next step |
| --- | --- |
| Package/version missing | Check recorded sources, `pkg update`, `apt-cache policy NAME`; names mode requests currently available versions. |
| `Exec format error` | Inspect with `file`; replace/emulate x86_64 host tools on ARM64. |
| `CANNOT LINK EXECUTABLE` | Check bionic/glibc compatibility and inherited LD_LIBRARY_PATH/LD_PRELOAD. |
| X11 blank | Open companion; verify display, server and window manager; consult upstream device rendering flags. |
| IDE fails | Inspect `.local/state/tablet-ide/server.log`, port 8080 and code-server configuration. |
| Browser scale wrong | Adjust custom launcher display flags. |
| Signal 9 | Review Android background/process limits and battery settings using Termux guidance. |
| APK build fails | Apply native AAPT2/NDK, QEMU Hermes and Prefab adjustments in the APK guide. |
| JavaFX fails | Verify Debian JDK/Maven, ARM64 JavaFX jars and shared X11 tmp. |
| rish unavailable | Restart/authorize Shizuku; check read-only DEX and battery settings. |
| Model unavailable | Restore/import weights; a manifest does not supply weights. |
| Android API fails | Check matching companion and Android permissions. |

Read-only inventory used termux-info, dpkg/apt metadata, pip/npm lists, proot-distro list, Debian package database parsing, filesystem and launcher inspection. Public files were reviewed for credential patterns before publication. No package installs, application builds, GUI sessions or model inference were executed. Upstream sources were consulted for Termux app signing and X11 installation.
