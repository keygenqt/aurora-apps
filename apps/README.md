Project structure for building packages and getting the necessary information using the Aurora CLI application.

Example:
```shell
.
├── apps
│   ├── com.keygenqt.rogue_shooter
│   │   ├── builds
│   │   │   ├── com.keygenqt.rogue_shooter-0.1.1-1.aarch64.rpm
│   │   │   ├── com.keygenqt.rogue_shooter-0.1.1-1.armv7hl.rpm
│   │   │   └── com.keygenqt.rogue_shooter-0.1.1-1.x86_64.rpm
│   │   ├── build.sh
│   │   ├── data
│   │   │   └── 172x172.png
│   │   ├── patches
│   │   │   ├── 001.patch
│   │   │   └── 002.patch
│   │   └── spec.json
```

- `com.keygenqt.rogue_shooter` - Application ID after build.
- `builds` - Folder with packages after execute `build.sh`.
- `build.sh` - Script build project.
- `data` - Folder with icon and other data.
- `patches` - Git patches applied to the project after cloning.
- `spec.json` - Info about project.

#### spec.json

The file that the application reads to obtain information about the project.

Example:
```json
{
    "name": "Rogue Shooter",
    "icon": "https://github.com/keygenqt/aurora-apps/blob/main/apps/com.keygenqt.rogue_shooter/data/172x172.png?raw=true",
    "desc": "This is a simple scrolling shooter game which we use for testing the performance of Flame.",
    "repo": "https://github.com/flame-engine/flame/tree/main/examples/games/rogue_shooter",
    "type": "flutter"
}
```

Types:

- `flutter` - Projects written in Flutter.
- `kmp` - Projects written using Kotlin Multiplatform.
- `pwa` - Projects written using WebView, etc.
- `qt` - Projects written in Qt.
