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

## Configuration files for VSCode

### settings.json

Open the command palette (either with F1 or Ctrl+Shift+P)
Type `open settings`
Select `Open Settings (JSON)`
Replace with settings.json from this repo


### keybindings.json

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
