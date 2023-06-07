# vscode-config

## Extensions for vscode

- Export Extensions

```sh
code --list-extensions > vscode-extensions.list
```

- Import Extension

```
cat vscode-extensions.list | xargs -L 1 code --install-extension
```

_Notes_

- For VSCodium use the `codium` command instead
- Enable the `code` and `codium` shell commands via the command palette:
  <S-C>P -> Shell -> Add Cod{e|ium} to Path
- To manually install an extension:
  - marketplace.visualstudiocode.com/\* > Resources > Download Extension
  - `code --install-extension downloaded-extension.vsix`

## Configuration files for VSCode

### settings.json

_VSCode_

- Windows
  %APPDATA%\Code\User\settings.json
- macOS
  $HOME/Library/Application\ Support/Code/User/settings.json
- Linux
  $HOME/.config/Code/User/settings.json

_VSCodium_

- Windows
  %APPDATA%\VSCodium\User\settings.json
- macOS
  $HOME/Library/Application\ Support/VSCodium/User/settings.json
- Linux
  $HOME/.config/VSCodium/User/settings.json

Open the command palette (either with F1 or Ctrl+Shift+P)
Type `open settings`
Select `Open Settings (JSON)`
Replace with settings.json from this repo

### keybindings.json

_VSCode_

- Windows:
  %UserProfile%\AppData\Roaming\Code\User\keybindings.json
- macOS:
  ~/Library/Application\ Support/Code/User/keybindings.json
- Linux:
  $HOME/.config/Code/User/keybindings.json

_VSCodium_

- Windows
  %APPDATA%\VSCodium\User\keybindings.json
- macOS
  $HOME/Library/Application\ Support/VSCodium/User/keybindings.json
- Linux
  $HOME/.config/VSCodium/User/keybindings.json

Open the command palette (either with F1 or Ctrl+Shift+P)
Type: "Open Keyboard Shortcuts" (JSON) command.
Select `Open Keyboard Shortcuts (JSON)`
Replace with keybindings.json from this repo

## Optional

### Suggested: Remap ESC to CAPS LOCK

- Linux ~/.xmodmap

```
! Swap caps lock and escape
remove Lock = Caps_Lock
keysym Escape = Caps_Lock
keysym Caps_Lock = Escape
add Lock = Caps_Lock
```

- Windows [ililim/dual-key-remap](https://github.com/ililim/dual-key-remap)

## License

MIT
