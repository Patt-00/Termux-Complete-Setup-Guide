# Exact restoration with a private backup

A private archive preserves home files, custom binaries, SDK/NDK trees, containers, models, accounts and project-bound scripts that package replay cannot recreate. Keep it offline and encrypted. It can contain tokens, signing keys, SSH keys, browser sessions and private conversations. Never publish it in this repository.

Stop IDE/Ollama/Gradle/PRoot/X11 sessions before backup so databases and files are not changing. Ensure enough storage. After granting shared-storage permission:

```sh
# Archive is outside files/, avoiding recursive inclusion.
tar --exclude='home/storage' -czpf \
  /storage/emulated/0/Download/termux-private-backup.tar.gz \
  -C /data/data/com.termux/files home usr
sha256sum /storage/emulated/0/Download/termux-private-backup.tar.gz
```

Container sessions must be stopped to avoid traversing exposed Android bind paths. Review tar errors; permission failures can mean an incomplete backup. Shared storage is not encrypted by this command. Encrypt/move the archive with a trusted tool and remove the unencrypted copy after verifying the encrypted copy.

The excluded storage links do not back up shared-storage models/files. Preserve those separately, plus exact Android APKs and permission settings. Installed Android apps and app data outside Termux's home/prefix are not included. Keep account recovery information privately.

Restore only to a fresh Termux with matching source, architecture, package name and paths. Initialize Termux once, transfer and verify the archive, and stop other sessions/services. This overwrites target files:

```sh
tar -xzpf /storage/emulated/0/Download/termux-private-backup.tar.gz \
  -C /data/data/com.termux/files
```

Restart Termux, recreate storage links using `termux-setup-storage`, regrant Android permissions and reauthorize accounts/Shizuku. Different hardware/Android versions can still require changes. No private archive was created or uploaded during documentation publication.
