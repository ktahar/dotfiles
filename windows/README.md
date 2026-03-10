# Windows

## Native
I live mainly on Git Bash on WezTerm.

### dotfiles (1st, cmd.exe)
Run cmd.exe with Admin privilege and `python install`

This would be the safest way to create symlinks properly.

### Programs
- Install Git for Windows.
- Install Python with the official installer.
- Add PATH env var from the Windows menu.
    - %APPDATA%\Python\Scripts
    - %APPDATA%\Python\Python3XY\Scripts

### dotfiles (2nd, Git Bash)
On git bash, `python install -g`

- `-g` installs WezTerm and CLI tools via winget.
- `fzf` for bash should be configured too.

### TeraTerm (deprecated)
Copy TERATERM.INI to TeraTerm's directory or just load settings from TeraTerm.

## WSL2
Launch PowerShell as Admin and `wsl.exe --install`.

### Windows Terminal
Copy "schemes" section to setting.json opened by "Ctrl + ," shortcut.

### dotfiles
`./install -pvw` at least (vim and python with WSL specific switch)
    - other options for programming languages will work.
    - won't need linux desktop options: `-d` or `-f`.
