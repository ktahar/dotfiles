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

def set_git_global_config():
    configs = [("core.excludesfile", "~/.gitignore_global"), 
            ("core.editor", "vim"), 
            ("user.name", "Kosuke Tahara"), 
            ("user.email", "ksk.tahara@gmail.com"), 
            ("push.default", "simple")]

    for k, v in configs:
        subprocess.run(['git', 'config', '--global', k, v])

def install_apt_packages():
    pkgs = [
            "ncurses-term",
            ]

    subprocess.run(['sudo', 'apt', 'install'] + pkgs)

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

    dirs = [r".vim", r".config\matplotlib", r".ipython\profile_default\startup"]

    for d in dirs:
        dn = os.path.join(home, d)

        if os.path.exists(dn):
            print("[INFO] already exists: %s" % dn)
        else:
            os.makedirs(dn)
            print("created dir %s" % dn)

    files = [(r"_vimrc", r".vimrc"),
            (r"_gvimrc", r".gvimrc"),
            (r".latexmkrc",)*2,
            (r".config\matplotlib\matplotlibrc",)*2,
            (r".ipython\profile_default\startup\ipython_startup.py",)*2,
            (r"vimfiles\skeleton.py", r".vim\skeleton.py"),
            (r"vimfiles\after", r".vim\after"),
            (r"vimfiles\plugin", r".vim\plugin"),
            (r"vimfiles\indent", r".vim\indent"),
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

    shutil.copy(os.path.join(home, "dotfiles\.vimrc.local.example"),
            os.path.join(home, "dotfiles\.vimrc.local"))
    print("Made file ~/dotfiles/.vimrc.local.")
    print("[WARN] Don't forget to edit this later.")

    vundle_path = os.path.join(home, r"vimfiles\bundle\Vundle.vim")
    if os.path.exists(vundle_path):
        print(r"[INFO] already exists: %s" % vundle_path)
    else:
        subprocess.run(['git', 'clone', 'https://github.com/VundleVim/Vundle.vim.git', vundle_path])

def main_posix():
    home = os.environ.get('HOME')

    dirs = [r".vim", r".config/matplotlib", r".ipython/profile_default/startup"]

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
            ]

    for f in files:
        ln = os.path.join(home, f[0])
        tgt = os.path.join(home, 'dotfiles', f[1])

        if os.path.exists(ln):
            print("[INFO] already exists: %s" % ln)
        else:
            os.symlink(tgt, ln)
            print("created sym link %s" % ln)

    git_repos = [("https://github.com/tmux-plugins/tmux-resurrect", ".tmux/plugins/tmux-resurrect"),
            ("https://github.com/VundleVim/Vundle.vim.git", ".vim/bundle/Vundle.vim"),
            ]
    for repo, path in git_repos: 
        path = os.path.join(home, path)
        if os.path.exists(path):
            print(r"[INFO] already exists: %s" % path)
        else:
            subprocess.run(['git', 'clone', repo, path])

    vimrc_local = os.path.join(home, "dotfiles", "vimrc.local")
    vimrc_local_example = os.path.join(home, "dotfiles", "vimrc.local.example")
    if os.path.exists(vimrc_local):
        print(r"[INFO] already exists: %s" % vimrc_local)
    else:
        shutil.copy(vimrc_local_example, vimrc_local)
        print("Made file ~/dotfiles/.vimrc.local.")
        print("Don't forget to edit this later.")

    contents = {'.bashrc': "source $HOME/dotfiles/bashrc\n"}
    for fn in contents:
        p = os.path.join(home, fn)
        with open(p) as f:
            if contents[fn] in f.read():
                print('%s has already been set up.' % p)
                continue
        print('Appending following contents to %s.' % p)
        print(contents[fn])
        if prompt('OK?'):
            with open(p, 'a') as f:
                f.write(contents[fn])

    set_git_global_config()
    install_apt_packages()

if __name__ == '__main__':
    if os.name == 'nt':
        main_windows()
    elif os.name == 'posix':
        main_posix()
    else:
        raise NotImplementedError("OS name %s is not supported." % os.name)

