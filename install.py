#!/usr/bin/env python3

import sys
import os
import shutil
import subprocess

if os.name == 'nt':
    home = os.environ.get('USERPROFILE')
else:
    home = os.environ.get('HOME')

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

def copy_vimrc_local():
    vimrc_local = os.path.join(home, "dotfiles", "vimrc.local")
    vimrc_local_example = os.path.join(home, "dotfiles", "vimrc.local.example")
    if os.path.exists(vimrc_local):
        print(r"[INFO] already exists: %s" % vimrc_local)
    else:
        shutil.copy(vimrc_local_example, vimrc_local)
        print("Made file ~/dotfiles/vimrc.local.")
        print("[WARN] Don't forget to edit this later.")

def install_from_github(posix):
    update = prompt('Programs from github. Update (Y) or just Install missing (N)')
    git_repos = [
            ("https://github.com/VundleVim/Vundle.vim.git",
                ".vim/bundle/Vundle.vim" if posix else r"vimfiles\bundle\Vundle.vim")
            ]

    if posix:
        git_repos.extend([
            ("https://github.com/tmux-plugins/tmux-resurrect",
            ".tmux/plugins/tmux-resurrect"),
            ("https://github.com/junegunn/fzf.git", ".fzf"),
            ])

    for repo, path in git_repos:
        path = os.path.join(home, path)
        if os.path.exists(path):
            if not update:
                print(r"[INFO] already exists: %s" % path)
            else:
                subprocess.run(['git', 'pull'], cwd=path)
        else:
            subprocess.run(['git', 'clone', '--depth', '1', repo, path])

    if posix:
        fzf_install = [os.path.join(home, '.fzf/install'),
                '--key-bindings',
                '--completion',
                '--no-update-rc',
                '--no-bash']
        subprocess.run(fzf_install)

def setup_shell():
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

def setup_vim(posix):
    if prompt('Vim Plugins. Update (Y) or just Install missing (N)'):
        vundle = 'VundleUpdate'
    else:
        vundle = 'VundleInstall'
    subprocess.run(['vim', '-c', vundle, '-c', ':qa'])

    if not prompt('Build YouCompleteMe?', default='n'):
        return
    print('Building YouCompleteMe...')
    ycm = ".vim/bundle/YouCompleteMe" if posix else r"vimfiles\bundle\YouCompleteMe"
    ycm = os.path.join(home, ycm)
    subprocess.run(['python3',
        './install.py', '--clang-completer'], cwd=ycm)

def set_git_global_config():
    configs = [("core.excludesfile", "~/.gitignore_global"),
            ("core.editor", "vim"),
            ("user.name", "Kosuke Tahara"),
            ("user.email", "ksk.tahara@gmail.com"),
            ("push.default", "simple"),
            ("credential.helper", "cache"),
            ("alias.graph", "log --graph --date=format:'%F %T' --pretty='%C(auto)%h [%ad]%d %C(green)%an%C(reset) : %s'"),
            ]

    for k, v in configs:
        subprocess.run(['git', 'config', '--global', k, v])

def install_apt_packages():
    pkgs = [
            "ncurses-term", "silversearcher-ag", "htop",
            "zsh", "zsh-doc", "zsh-syntax-highlighting",
            "exuberant-ctags", "global", "ttf-mscorefonts-installer",
            # python libs
            "python-pip", "python3-pip",
            "python-numpy", "python3-numpy",
            "python-matplotlib", "python3-matplotlib",
            # to build YouCompleteMe
            "build-essential", "cmake", "python3-dev",
            ]

    subprocess.run(['sudo', '-E', 'apt', 'install'] + pkgs)

def remove_apt_py_packages():
    """remove apt python packages which I install from pip.

    For ROS, I can't remove "python-numpy" and "python-matplotlib".
    Other libraries may dependent on "python3-numpy" and "python3-matplotlib",
    so we won't remove these either.
    """

    pkgs = [
            "python-scipy", "python-pandas", "ipython",
            "python3-scipy", "python3-pandas", "ipython3",
            ]

    subprocess.run(['sudo', 'apt', 'remove'] + pkgs)
    subprocess.run(['sudo', 'apt', 'autoremove'])

def install_pip_packages():
    """install python packages using pip.

    Because this will install with --user option,
    installed packages will be located in ~/.local.

    Matplotlib and pandas depend on python-dateutil,
    but pandas needs newer version.
    (And not automatically upgraded to that version.)
    So, upgrade python-dateutil explicitly.

    """

    opts = ['install', '--user']
    if prompt('pip packages. Update (Y) or just Install missing (N)'):
        opts.append('-U')

    pkgs = [
            "pip", "numpy", "matplotlib", "python-dateutil",
            "scipy", "pandas", "ipython",
            ]
    pkgs_2 = []
    pkgs_3 = ["rospkg"]

    subprocess.run(['pip2'] + opts + pkgs + pkgs_2)
    subprocess.run(['pip3'] + opts + pkgs + pkgs_3)

def main_windows():
    """make directories and symbolic links for windows.

    Note that you should run this script with Administrator privilege.
    Creates hardlinks and junctions if executed without Admin. priv.

    """

    import ctypes

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
    copy_vimrc_local()
    install_from_github(False)

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
    copy_vimrc_local()
    install_from_github(True)
    set_git_global_config()
    setup_shell()
    install_apt_packages()
    if prompt('clean apt packages and install (upgrade) pip packages?'):
        remove_apt_py_packages()
        install_pip_packages()
    setup_vim(True)

if __name__ == '__main__':
    if os.name == 'nt':
        main_windows()
    elif os.name == 'posix':
        main_posix()
    else:
        raise NotImplementedError("OS name %s is not supported." % os.name)

