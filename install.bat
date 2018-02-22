cd %USERPROFILE%
mklink _vimrc dotfiles\.vimrc
mklink _gvimrc dotfiles\.gvimrc
mklink .latexmkrc dotfiles\.latexmkrc
mklink .matplotlib\matplotlibrc ..\dotfiles\.config\matplotlib\matplotlibrc
mklink vimfiles\skeleton.py ..\dotfiles\.vim\skeleton.py
mklink /D vimfiles\after ..\dotfiles\.vim\after
echo DONE...
pause
