#!/usr/bin/env python3

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
    raise NotImplementedError("This is todo.")

if __name__ == '__main__':
    if os.name == 'nt':
        main_windows()
    elif os.name == 'posix':
        main_posix()
    else:
        raise NotImplementedError("OS name %s is not supported." % os.name)

