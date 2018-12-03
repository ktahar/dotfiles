#!/usr/bin/env python3

import sys
import os
import shutil
import subprocess

def prompt(msg, default='y'):
    if sys.version_info.major == 2: inp = raw_input
    else: inp = input

    if not isinstance(default, str): default = ''
    default = default.lower()

    if default == 'y':
        return inp('%s [Y/n]:' % msg).lower() != 'n'
    elif default == 'n':
        return inp('%s [y/N]:' % msg).lower() == 'y'
    else:
        while True:
            a = inp('%s [y/n]:' % msg).lower()
            if a == 'y':
                return True
            elif a == 'n':
                return False

def copy_vimrc_local(home):
    vimrc_local = os.path.join(home, "dotfiles", "vimrc.local")
    vimrc_local_example = os.path.join(home, "dotfiles", "vimrc.local.example")
    if os.path.exists(vimrc_local):
        print(r"[INFO] already exists: %s" % vimrc_local)
    else:
        shutil.copy(vimrc_local_example, vimrc_local)
        print("Made file ~/dotfiles/vimrc.local.")
        print("[WARN] Don't forget to edit this later.")

def clone_git_repos(home, posix):
    git_repos = [
            ("https://github.com/VundleVim/Vundle.vim.git",
                ".vim/bundle/Vundle.vim" if posix else r"vimfiles\bundle\Vundle.vim")
            ]

    if posix:
        git_repos.append(("https://github.com/tmux-plugins/tmux-resurrect", ".tmux/plugins/tmux-resurrect"))

    for repo, path in git_repos:
        path = os.path.join(home, path)
        if os.path.exists(path):
            print(r"[INFO] already exists: %s" % path)
        else:
            if shutil.which('proxy.sh') is not None:
                subprocess.run(['proxy.sh', 'git', 'clone', repo, path])
            elif shutil.which('proxy.bat') is not None:
                subprocess.run(['proxy.bat', 'git', 'clone', repo, path])
            else:
                subprocess.run(['git', 'clone', repo, path])

def setup_shell(home):
    contents = {'.bashrc': "source $HOME/dotfiles/bashrc\n",
            '.zshrc': "source $HOME/dotfiles/zshrc\n",
            '.zshenv': "source $HOME/dotfiles/zshenv\n"}
    for fn in contents:
        p = os.path.join(home, fn)

        if not os.path.exists(p):
            print('Writing following contents to %s.' % p)
            print(contents[fn])
            if prompt('OK?'):
                with open(p, 'w') as f:
                    f.write(contents[fn])
            continue

        with open(p) as f:
            if contents[fn] in f.read():
                print('[INFO] %s has already been set up.' % p)
                continue

        print('Appending following contents to %s.' % p)
        print(contents[fn])
        if prompt('OK?'):
            with open(p, 'a') as f:
                f.write(contents[fn])

    if 'SHELL' in os.environ and os.environ['SHELL'] == '/bin/zsh':
        print('[INFO] Already using zsh.')
    else:
        if prompt('Change default shell to /bin/zsh?'):
            subprocess.run(['chsh', '-s', '/bin/zsh'])

def setup_vim(home, posix):
    print('Installing vim Plugins...')
    if shutil.which('proxy.sh') is not None:
        subprocess.run(['proxy.sh', 'vim', '-c', 'VundleInstall', '-c', ':qa'])
    else:
        subprocess.run(['vim', '-c', 'VundleInstall', '-c', ':qa'])

    if not prompt('Build YouCompleteMe?', default='n'):
        return
    print('Building YouCompleteMe...')
    ycm = ".vim/bundle/YouCompleteMe" if posix else r"vimfiles\bundle\YouCompleteMe"
    ycm = os.path.join(home, ycm)
    if shutil.which('proxy.sh') is not None:
        subprocess.run(['proxy.sh', 'python3',
            './install.py', '--clang-completer'], cwd=ycm)
    else:
        subprocess.run(['python3',
            './install.py', '--clang-completer'], cwd=ycm)

def set_git_global_config():
    configs = [("core.excludesfile", "~/.gitignore_global"),
            ("core.editor", "vim"),
            ("user.name", "Kosuke Tahara"),
            ("user.email", "ksk.tahara@gmail.com"),
            ("push.default", "simple"),
            ("credential.helper", "cache")]

    for k, v in configs:
        subprocess.run(['git', 'config', '--global', k, v])

def install_apt_packages():
    pkgs = [
            "ncurses-term", "silversearcher-ag",
            "zsh", "zsh-doc", "zsh-syntax-highlighting",
            "exuberant-ctags", "global", "ttf-mscorefonts-installer",
            "python-pip", "python3-pip",
            # to build YouCompleteMe
            "build-essential", "cmake", "python3-dev",
            ]

    if shutil.which('proxy.sh') is not None:
        subprocess.run(['proxy.sh', 'sudo', '-E', 'apt', 'install'] + pkgs)
    else:
        subprocess.run(['sudo', 'apt', 'install'] + pkgs)

def remove_apt_py_packages():
    """remove apt python packages which I install from pip.

    For ROS, I can't remove "python-numpy" and "python-matplotlib".
    """

    pkgs = [
            "python-scipy", "python-pandas", "ipython",
            "python3-numpy", "python3-matplotlib",
            "python3-scipy", "python3-pandas", "ipython3",
            ]

    subprocess.run(['sudo', 'apt', 'remove'] + pkgs)
    subprocess.run(['sudo', 'apt', 'autoremove'])

def install_pip_packages():
    """install python packages using pip.

    Because this will install with --user option,
    installed packages will be located in ~/.local.
    """

    pkgs = [
            "pip", "numpy", "matplotlib",
            "scipy", "pandas", "ipython",
            ]

    if shutil.which('proxy.sh') is not None:
        subprocess.run(['proxy.sh', 'pip2', 'install', '--user', '-U'] + pkgs)
        subprocess.run(['proxy.sh', 'pip3', 'install', '--user', '-U'] + pkgs)
    else:
        subprocess.run(['pip2', 'install', '--user', '-U'] + pkgs)
        subprocess.run(['pip3', 'install', '--user', '-U'] + pkgs)

def main_windows():
    """make directories and symbolic links for windows.

    Note that you should run this script with Administrator privilege.
    Creates hardlinks and junctions if executed without Admin. priv.

    """

    import ctypes

    home = os.environ.get('USERPROFILE')
    kdll = ctypes.windll.LoadLibrary("kernel32.dll")
    shdll = ctypes.windll.LoadLibrary("Shell32.dll")

    admin = shdll.IsUserAnAdmin()
    if not admin:
        print("You don't have Administrator priviledge. If you can get it, I recommend to install with it.")
        if not prompt('Install anyway?', 'n'):
            return

    dirs = [r"vimfiles", r".config\matplotlib", r".ipython\profile_default\startup"]

    for d in dirs:
        dn = os.path.join(home, d)

        if os.path.exists(dn):
            print("[INFO] already exists: %s" % dn)
        else:
            os.makedirs(dn)
            print("created dir %s" % dn)

    files = [(r"_vimrc", r"vimrc"),
            (r"_gvimrc", r"gvimrc"),
            (r".latexmkrc", r"latexmkrc"),
            (r".config\matplotlib\matplotlibrc", r"matplotlibrc"),
            (r".ipython\profile_default\startup\ipython_startup.py", r"ipython_startup.py"),
            (r"vimfiles\skeleton.py", r"vim\skeleton.py"),
            (r"vimfiles\after", r"vim\after"),
            (r"vimfiles\plugin", r"vim\plugin"),
            (r"vimfiles\indent", r"vim\indent"),
            ]

    for f in files:
        ln = os.path.join(home, f[0])
        tgt = os.path.join(home, 'dotfiles', f[1])

        if os.path.exists(ln):
            print("[INFO] already exists: %s" % ln)
        else:
            isdir = 1 if os.path.isdir(tgt) else 0
            if admin:
                ret = kdll.CreateSymbolicLinkW(ln, tgt, isdir)
                if ret == 1:
                    print("created sym link %s" % ln)
                else:
                    print("[ERROR] maybe failed to create link %s (ret code: %d)" % (ln, ret))
                    print("[ERROR] be sure to run as Administrator")
            elif not isdir:
                ret = kdll.CreateHardLinkW(ln, tgt, None)
                if ret:
                    print("created hard link %s" % ln)
                else:
                    print("[ERROR] maybe failed to create link %s (ret code: %d)" % (ln, ret))
            else:
                # create junction to the directory (no win api?)
                subprocess.run(['mklink', '/J', ln, tgt], shell=True)
                print("created junction %s" % ln)

    # additional things
    copy_vimrc_local(home)
    clone_git_repos(home, False)

def main_posix():
    home = os.environ.get('HOME')

    dirs = [r".vim", r".config/matplotlib",
            r".ipython/profile_default/startup", r"tmp",
            r".config/gtk-3.0"]

    for d in dirs:
        dn = os.path.join(home, d)

        if os.path.exists(dn):
            print("[INFO] already exists: %s" % dn)
        else:
            os.makedirs(dn)
            print("created dir %s" % dn)

    files = [(r".vimrc", r"vimrc"),
            (r".gvimrc", r"gvimrc"),
            (r".tmux.conf", r"tmux.conf"),
            (r".ctags", r"ctags"),
            (r".gitignore_global", r"gitignore_global"),
            (r".agignore", r"agignore"),
            (r".latexmkrc", r"latexmkrc"),
            (r".config/matplotlib/matplotlibrc", r"matplotlibrc"),
            (r".ipython/profile_default/startup/ipython_startup.py", r"ipython_startup.py"),
            (r".vim/skeleton.py", r"vim/skeleton.py"),
            (r".vim/after", r"vim/after"),
            (r".vim/plugin", r"vim/plugin"),
            (r".vim/indent", r"vim/indent"),
            (r".config/gtk-3.0/gtk.css", r"gnome/gtk.css"),
            ]

    for f in files:
        ln = os.path.join(home, f[0])
        tgt = os.path.join(home, 'dotfiles', f[1])

        if os.path.exists(ln):
            print("[INFO] already exists: %s" % ln)
        else:
            os.symlink(tgt, ln)
            print("created sym link %s" % ln)

    # additional things
    copy_vimrc_local(home)
    clone_git_repos(home, True)
    set_git_global_config()
    setup_shell(home)
    install_apt_packages()
    if prompt('clean apt packages and install (upgrade) pip packages?', default='n'):
        remove_apt_py_packages()
        install_pip_packages()
    setup_vim(home, True)

if __name__ == '__main__':
    if os.name == 'nt':
        main_windows()
    elif os.name == 'posix':
        main_posix()
    else:
        raise NotImplementedError("OS name %s is not supported." % os.name)

