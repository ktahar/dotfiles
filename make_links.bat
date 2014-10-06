cd %USERPROFILE%
mklink _vimrc dotfiles\.vimrc
mklink _gvimrc dotfiles\.gvimrc
mklink .matplotlib\matplotlibrc ..\dotfiles\matplotlibrc
mklink .unison\nas_graphene.prf ..\dotfiles\nas_graphene.prf
mklink .unison\nas_nv.prf ..\dotfiles\nas_nv.prf
mklink .unison\nas_tahara.prf ..\dotfiles\nas_tahara.prf
mklink .unison\usb.prf ..\dotfiles\usb.prf
echo DONE...
pause
