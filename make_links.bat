cd %USERPROFILE%
mklink _vimrc dotfiles\.vimrc
mklink _gvimrc dotfiles\.gvimrc
mklink .matplotlib\matplotlibrc ..\dotfiles\matplotlibrc
mklink .unison\nas_graphene.prf ..\dotfiles\nas_graphene.prf
mklink .unison\nas_nv.prf ..\dotfiles\nas_nv.prf
mklink .unison\nas_tahara.prf ..\dotfiles\nas_tahara.prf
mklink .unison\usb.prf ..\dotfiles\usb.prf
mklink .unison\nv.prf ..\dotfiles\nv.prf
mklink .unison\nv_manual.prf ..\dotfiles\nv_manual.prf
mklink vimfiles\skeleton.py ..\dotfiles\.vim\skeleton.py
mklink /D vimfiles\after ..\dotfiles\.vim\after
mklink /D vimfiles\bundle.nosync ..\dotfiles\.vim\bundle.nosync
echo DONE...
pause
