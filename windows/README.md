# Windows

It's difficult to automate everything on Windows.
So here are things I do manually.

## Native
I live mainly on Git Bash on WezTerm.

### Programs
- Install Git for Windows.
- Install Python with the official installer.
- `winget wez.wezterm BurntSushi.ripgrep.MSVC UniversalCtags.Ctags`

### dotfiles
`python install` (no options)

fzf will be downloaded automatically when I hit the command on Git Bash for the first time.
But to install it explicitly,
execute `apps/fzf/install.ps1` in PowerShell (`PowerShell -ExecutionPolicy RemoteSigned .\install.ps1`).

### Environment variables
- PATH
    - %APPDATA%\Python\Scripts
    - %APPDATA%\Python\Python3XY\Scripts
    - %USERPROFILE%\.fzf\bin
- fzf (see zshenv)
    - FZF_DEFAULT_OPTS='--bind=ctrl-j:abort'
    - FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'

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
