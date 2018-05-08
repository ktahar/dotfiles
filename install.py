#!/usr/bin/env python3

import os
import subprocess

def main_windows():
    """make directories and symbolic links for windows.

    Note that you must run this script with Administrator privilege.
    """

    import ctypes

    home = os.environ.get('USERPROFILE')
    kdll = ctypes.windll.LoadLibrary("kernel32.dll")
    shdll = ctypes.windll.LoadLibrary("Shell32.dll")

    if not shdll.IsUserAnAdmin():
        raise RuntimeError("This script have to be run as an Administrator")

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
            ret = kdll.CreateSymbolicLinkW(ln, tgt, isdir)
            if ret == 1:
                print("created link %s" % ln)
            else:
                print("[ERROR] maybe failed to create link %s (ret code: %d)" % (ln, ret))
                print("[ERROR] be sure to run as Administrator")

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

