#!/usr/bin/env python3

import sys
import os
import shutil
import subprocess
import argparse

if os.name == 'nt':
    home = os.environ.get('USERPROFILE')
else:
    home = os.environ.get('HOME')
p = os.path.join(home, 'dotfiles', 'py')
if p not in sys.path:
    sys.path.append(p)
from colour import printc

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

def setup_apps():
    """setup applications.

    [vim]
    On linux desktop, option +clipboard (+X11) turns on with configure --with-features=huge.
    However, configuration of X fails sometimes (which result in -clipboard (-X11)).
    Maybe Ubuntu 18's Wayland-or-X things are problematic.
    Proper build is confirmed after installing vanilla-gnome-desktop and logged in with 'GNOME on Xorg'.
    When you changed X config / situations,
    try following to remove config cache (vim/src/auto/config.cache) and then configure & make again.
    cd ~/dotfiles/apps/vim/src && make distclean

    """

    fzf_install = [os.path.join(home, '.fzf/install'),
            '--key-bindings',
            '--completion',
            '--no-update-rc',
            '--no-bash']
    subprocess.run(fzf_install)

    # check commit hash of HEAD
    head = os.path.join(home, "dotfiles/apps/vim.HEAD")
    if os.path.exists(head):
        with open(head) as f:
            hlast = f.readline()
    else:
        hlast = None

    res = subprocess.run(['git', 'rev-parse', '--short', 'HEAD'],
            cwd=os.path.join(home, "dotfiles/apps/vim"),
            stdout=subprocess.PIPE)
    hnow = res.stdout.decode()

    if hnow != hlast and prompt('Build Vim?'):
        vim_conf = ['./configure',
                '--prefix={}/.local'.format(home),
                '--with-features=huge',
                '--enable-gui=no',
                #  '--with-x=yes', # seems enabled implicitly.
                '--enable-python3interp',
                '--enable-fail-if-missing',
                ]
        subprocess.run(vim_conf,
                cwd=os.path.join(home, "dotfiles/apps/vim/src"))
        subprocess.run(["make", "install"],
                cwd=os.path.join(home, "dotfiles/apps/vim/src"))

        with open(head, 'w') as f:
            f.write(hnow)

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

def install_apt_packages(upgrade):
    subprocess.run(['sudo', '-E', 'apt', 'update'])

    if upgrade:
        subprocess.run(['sudo', '-E', 'apt', 'upgrade'])

    pkgs = [
            "ncurses-term", "silversearcher-ag", "htop", "tree", "curl",
            "tmux", "zsh", "zsh-doc", "zsh-syntax-highlighting",
            "exuberant-ctags", "global", "pandoc", "unison", "p7zip-full",
            "ttf-mscorefonts-installer",
            # I personally use vim built from source instead of this one.
            # But install apt-pack vim here for root or other users.
            "vim",
            # python libs
            "python-dev", "python3-dev",
            "python-pip", "python3-pip",
            "python-numpy", "python3-numpy",
            "python-matplotlib", "python3-matplotlib",
            # Build tools
            "build-essential", "cmake",
            # deps to build vim
            "git", "gettext", "libtinfo-dev", "libacl1-dev", "libgpm-dev",
            "clang-tools-6.0", # to use clangd-6.0 from vim-lsp.
            # Ruby and Jekyll
            "ruby-full", "zlib1g-dev",
            # Ocaml
            "ocaml", "opam",
            ]

    res = subprocess.run(['dpkg-query', '-W'] + pkgs,
            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    if res.returncode:
        subprocess.run(['sudo', '-E', 'apt', 'install'] + pkgs)

def install_pip_packages(upgrade):
    """install python packages using pip.

    Because this will install with --user option,
    installed packages will be located in ~/.local.

    Matplotlib and pandas depend on python-dateutil,
    but pandas needs newer version.
    (And not automatically upgraded to that version.)
    So, upgrade python-dateutil explicitly.

    """

    # prefer pip at ~/.local/bin
    local_bin = os.path.join(home, '.local', 'bin')

    # install/upgrade pip first
    for pip in ('pip2', 'pip3'):
        local_pip = os.path.join(local_bin, pip)
        if os.path.exists(local_pip):
            subprocess.run([local_pip, 'install', '--user', '-U', 'pip'])
        else:
            subprocess.run([pip, 'install', '--user', '-U', 'pip'])

    opts = ['install', '--user']
    if upgrade:
        opts.append('-U')

    pkgs = [
            "pip", "python-dateutil", "numpy", "matplotlib",
            "scipy", "pandas", "ipython",
            ]
    pkgs_2 = []
    pkgs_3 = [
            "pipenv",
            "jedi", "python-language-server", # to use pyls from vim-lsp.
            "rospkg",
            "panflute",
            "ewmh", # for window focus control in fwdevince
            ]

    subprocess.run([os.path.join(local_bin, 'pip2')] + opts + pkgs + pkgs_2)
    subprocess.run([os.path.join(local_bin, 'pip3')] + opts + pkgs + pkgs_3)

def install_gem_packages():
    """install ruby packages using gem.

    """

    pkgs = [
            "jekyll", "bundler",
            ]

    subprocess.run(['gem', 'install'] + pkgs)

def install_opam_packages():
    """install OCaml packages using opam.

    """

    if not os.path.exists(os.path.join(home, '.opam')):
        subprocess.run(['opam', 'init'])
        printc("[WARN] opam init is done but opam install is skipped. restart the shell and run install.py again.", 'y')
        return

    pkgs = [
            "merlin", "utop",
            ]

    subprocess.run(['opam', 'install'] + pkgs)

    # setup merlin.
    ret = subprocess.run(['opam', 'config', 'var', 'share'], stdout=subprocess.PIPE)
    opam_share = ret.stdout.decode().strip()
    merlin_path = os.path.join(opam_share, 'merlin', 'vim')
    doc_path = os.path.join(merlin_path, 'doc')

    ## create symlink for merlin as vim pack.
    pack_path = os.path.join(home, 'dotfiles', 'vim', 'pack', 'my', 'start', 'merlin')
    if not os.path.exists(pack_path):
        os.symlink(merlin_path, pack_path)
        printc("created sym link %s" % pack_path, 'g')

    ## generate helptags for merlin.
    subprocess.run(['vim', '-c', 'helptags ' + doc_path, '-c', 'quit'])

def main_windows(args):
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

    dirs = [r".config\matplotlib", r".ipython\profile_default\startup"]

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
            (r"vimfiles", r"vim"),
            (r".minttyrc", r"windows\minttyrc"),
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

def dirs_and_links_linux(args):
    dirs = [r".tmux", r".config/matplotlib",
            r".ipython/profile_default/startup", r"tmp",
            r".config/gtk-3.0"]

    printc('[create dirs]', 'b')
    for d in dirs:
        dn = os.path.join(home, d)

        if os.path.exists(dn):
            print("[INFO] already exists: %s" % dn)
        else:
            os.makedirs(dn)
            printc("created dir %s" % dn, 'g')

    files = [
            (r".vimrc", r"vimrc"),
            (r".gvimrc", r"gvimrc"),
            (r".vim", r"vim"),
            (r".ideavimrc", r"ideavimrc"),
            (r".tmux.conf", r"tmux.conf"),
            (r".tmux/plugins", r"tmux/plugins"),
            (r".fzf", r"apps/fzf"),
            (r".ctags", r"ctags"),
            (r".gitignore_global", r"gitignore_global"),
            (r".agignore", r"agignore"),
            (r".latexmkrc", r"latexmkrc"),
            (r".ocamlinit", r"ocamlinit"),
            (r".utoprc", r"utoprc"),
            (r".lambda-term-inputrc", r"lambda-term-inputrc"),
            (r".config/matplotlib/matplotlibrc", r"matplotlibrc"),
            (r".ipython/profile_default/startup/ipython_startup.py", r"ipython_startup.py"),
            (r".config/gtk-3.0/gtk.css", r"gnome/gtk.css"),
            ]

    printc('[create links]', 'b')
    for f in files:
        ln = os.path.join(home, f[0])
        tgt = os.path.join(home, 'dotfiles', f[1])

        if os.path.exists(ln):
            print("[INFO] already exists: %s" % ln)
        else:
            os.symlink(tgt, ln)
            printc("created sym link %s" % ln, 'g')

def main_linux(args):
    printc('[dirs and links]', 'b')
    dirs_and_links_linux(args)
    printc('[vimrc local]', 'b')
    copy_vimrc_local()
    printc('[git global config]', 'b')
    set_git_global_config()

    if args.all or args.apt:
        printc('[apt packages]', 'b')
        install_apt_packages(args.upgrade)
    if args.all or args.pip:
        printc('[pip packages]', 'b')
        install_pip_packages(args.upgrade)
    if args.all or args.gem:
        printc('[gem packages]', 'b')
        install_gem_packages()
    if args.all or args.opam:
        printc('[opam packages]', 'b')
        install_opam_packages()

    # shell and apps should be later than apt.
    printc('[shell]', 'b')
    setup_shell()
    printc('[apps]', 'b')
    setup_apps()

def parse_args():
    parser = argparse.ArgumentParser(description='Install my dotfiles etc.')
    parser.add_argument('-U', '--upgrade', action='store_true',
            help='Upgrade packages etc.')
    parser.add_argument('-A', '--all', action='store_true',
            help='Install packages from all package managers.')
    parser.add_argument('-a', '--apt', action='store_true',
            help='Install apt packages.')
    parser.add_argument('-p', '--pip', action='store_true',
            help='Install pip packages.')
    parser.add_argument('-g', '--gem', action='store_true',
            help='Install gem packages.')
    parser.add_argument('-o', '--opam', action='store_true',
            help='Installing opam packages.')

    return parser.parse_args()

if __name__ == '__main__':
    args = parse_args()

    if os.name == 'nt':
        main_windows(args)
    elif os.name == 'posix':
        main_linux(args)
    else:
        raise NotImplementedError("OS name %s is not supported." % os.name)

