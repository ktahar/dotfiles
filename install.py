#!/usr/bin/env python3

import sys
import os
from os import path
import glob
import shutil
import subprocess
import argparse
import platform

osname = platform.system()
if osname == 'Windows':
    home = os.environ.get('USERPROFILE')
else:
    home = os.environ.get('HOME')
if osname == 'Linux':
    distname, distversion, distid = platform.linux_distribution()

py = path.join(home, 'dotfiles', 'py')
if py not in sys.path:
    sys.path.append(py)
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
        dn = path.join(home, d)

        if path.exists(dn):
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
        ln = path.join(home, f[0])
        tgt = path.join(home, 'dotfiles', f[1])

        if path.exists(ln):
            print("[INFO] already exists: %s" % ln)
        else:
            isdir = 1 if path.isdir(tgt) else 0
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

def setup_fzf():
    """setup fzf.

    """

    fzf_install = [path.join(home, '.fzf/install'),
            '--key-bindings',
            '--completion',
            '--no-update-rc',
            '--no-bash']
    subprocess.run(fzf_install)

def setup_vim():
    """setup vim.

    Note:
    On linux desktop, option +clipboard (+X11) turns on with configure --with-features=huge.
    However, configuration of X fails sometimes (which result in -clipboard (-X11)).
    Maybe Ubuntu 18's Wayland-or-X things are problematic.
    Proper build is confirmed after installing vanilla-gnome-desktop and logged in with 'GNOME on Xorg'.
    When you changed X config / situations,
    try following to remove config cache (vim/src/auto/config.cache) and then configure & make again.
    cd ~/dotfiles/apps/vim/src && make distclean

    """

    # Build
    ## check commit hash of HEAD
    head = path.join(home, "dotfiles/apps/vim.HEAD")
    if path.exists(head):
        with open(head) as f:
            hlast = f.readline()
    else:
        hlast = None

    res = subprocess.run(['git', 'rev-parse', '--short', 'HEAD'],
            cwd=path.join(home, "dotfiles/apps/vim"),
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
                cwd=path.join(home, "dotfiles/apps/vim/src"))
        subprocess.run(["make", "install"],
                cwd=path.join(home, "dotfiles/apps/vim/src"))

        with open(head, 'w') as f:
            f.write(hnow)

    # Generate helptags
    docs = path.join(home, "dotfiles", "vim", "pack", "my", "start", "*", "doc")
    ## Don't pass many commands to vim like -c helptags p0 -c helptags p1 ...
    ## since there's upper limit of accepted number of commands
    ## (`man 1 vim` says it's 10, but I choose safer way; do it one-by-one.)
    vim = path.join(home, ".local", "bin", "vim")
    for p in glob.glob(docs):
        subprocess.run([vim, '-c', 'helptags ' + p, '-c', 'quit'])

def setup_shell():
    contents = {'.bashrc': "source $HOME/dotfiles/bashrc\n",
            '.zshrc': "source $HOME/dotfiles/zshrc\n",
            '.zshenv': "source $HOME/dotfiles/zshenv\n"}
    for fn in contents:
        p = path.join(home, fn)

        if not path.exists(p):
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
            "ncurses-term", "silversearcher-ag", "htop", "tree", "curl", "wget",
            "git", "mercurial", "darcs", # for some package managers
            "tmux", "zsh", "zsh-doc", "zsh-syntax-highlighting",
            "exuberant-ctags", "global", "pandoc", "unison", "p7zip-full",
            "ttf-mscorefonts-installer", "rlwrap",
            "clang-tools-6.0", ## to use clangd-6.0 from vim-lsp.
            "m4", ## for opam package conf-m4
            # I personally use vim built from source instead of this one.
            # But install apt-pack vim here for root or other users.
            "vim",
            # languages
            "ruby-full", "sbcl",
            ## python libs
            "python-dev", "python3-dev",
            "python-pip", "python3-pip",
            "python-numpy", "python3-numpy",
            "python-matplotlib", "python3-matplotlib",
            # build tools
            "build-essential", "cmake", "llvm",
            # dev libs
            ## to build python
            "libssl-dev", ## also for ruby gem package openssl
            "zlib1g-dev", ## also for ruby gem package jekyll
            "libbz2-dev", "libreadline-dev", "libsqlite3-dev",
            "libncurses5-dev", "xz-utils", "tk-dev",
            "libxml2-dev", "libxmlsec1-dev", "libffi-dev", "liblzma-dev",
            ## to build vim
            "gettext", "libtinfo-dev", "libacl1-dev", "libgpm-dev",
            "xorg-dev", ## to enable +clipboard +X11
            ## i3wm and things on it
            "i3", "rxvt-unicode",
            ]

    if distid == 'xenial':
        pkgs.append("libcap-dev") # to build bubblewrap for opam
    else:
        pkgs.append("bubblewrap") # for opam

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
    local_bin = path.join(home, '.local', 'bin')

    # install/upgrade pip first
    for pip in ('pip2', 'pip3'):
        local_pip = path.join(local_bin, pip)
        if path.exists(local_pip):
            subprocess.run([local_pip, 'install', '--user', '-U', 'pip'])
        else:
            subprocess.run([pip, 'install', '--user', '-U', 'pip'])

    opts = ['install', '--user']
    if upgrade:
        opts.append('-U')

    pkgs = [
            "pip", "setuptools", "testresources", "python-dateutil", "numpy", "matplotlib",
            "scipy", "pandas", "ipython",
            ]
    pkgs_2 = []
    pkgs_3 = [
            "pipenv",
            "cvxopt",
            "jedi", "python-language-server", # to use pyls from vim-lsp.
            "rospkg",
            "panflute",
            "requests",
            "ewmh", # for window focus control in fwdevince
            ]

    subprocess.run([path.join(local_bin, 'pip2')] + opts + pkgs + pkgs_2)
    subprocess.run([path.join(local_bin, 'pip3')] + opts + pkgs + pkgs_3)

def install_gem_packages(upgrade):
    """install ruby packages using gem.

    """

    if upgrade:
        subprocess.run(['gem', 'update'])

    pkgs = [
            "jekyll", "bundler",
            ]

    subprocess.run(['gem', 'install'] + pkgs)

def install_opam_packages(upgrade):
    """install OCaml packages using opam.

    [bubblewrap]
    required by OPAM 2.0.
    While Ubuntu 18.04+ has apt package for this,
    Ubuntu 16.04 doesn't. So, build from source.

    """

    def install_bwrap():
        if not (osname == 'Linux' and distid == 'xenial'):
            msg = "You don't have to build bwrap on platform other than Ubuntu 16.04."
            msg += "\nYou can install it from apt (run ./install.py -a)."
            raise RuntimeError(msg)

        wd = path.join(home, "dotfiles", "apps", "bubblewrap")
        subprocess.run(['./autogen.sh'], cwd=wd)
        subprocess.run(['./configure', '--prefix={}/.local'.format(home),
            '--disable-man'], cwd=wd)
        subprocess.run(['make', 'clean'], cwd=wd)
        subprocess.run(['make'], cwd=wd)
        subprocess.run(['install', '-c', 'bwrap', "{}/.local/bin".format(home)],
                cwd=wd)

    def install_opam(opam):
        """install opam itself to ~/.local/bin.

        """

        import requests, hashlib
        version = "2.0.4"
        h = "e6b7e5657b1692c351c29a952960d1a0c3ea3df0fb0311744a35c9b518987d4978fed963d4b3f04d2fac2348a914834f7ce464fda766efa854556554c56a33b6"
        name = "opam-{}-x86_64-linux".format(version)
        print("Downloading", name)
        url = "https://github.com/ocaml/opam/releases/download/{}/{}".format(
                version, name)
        res = requests.get(url)
        if hashlib.sha512(res.content).hexdigest() != h:
            raise RuntimeError("SHA512 hash of opam binary doesn't match!")
        with open(opam, 'wb') as f:
            f.write(res.content)
        os.chmod(opam, 0o755)

    if not shutil.which("bwrap"):
        install_bwrap()

    opam = path.join(home, ".local", "bin", "opam")
    if not path.exists(opam):
        install_opam(opam)

    if not path.exists(path.join(home, '.opam')):
        subprocess.run([opam, 'init'])
        printc("[WARN] opam init is done but opam install is skipped. type eval $(opam env), and run ./install.py -o again.", 'y')
        return

    subprocess.run([opam, 'update'])
    if upgrade:
        subprocess.run([opam, 'upgrade'])

    pkgs = [
            "merlin", "utop", "ocp-indent",
            ]

    subprocess.run([opam, 'install'] + pkgs)

    # setup merlin and ocp-indent.
    ret = subprocess.run([opam, 'config', 'var', 'share'], stdout=subprocess.PIPE)

    opam_share = ret.stdout.decode().strip()

    ## create symlink for `pkg` as vim pack.
    for pkg in ('merlin', 'ocp-indent'):
        pkg_path = path.join(opam_share, pkg, 'vim')
        pack_path = path.join(home, 'dotfiles',
                'vim', 'pack', 'my', 'start', pkg)
        if not path.exists(pack_path):
            os.symlink(pkg_path, pack_path)
            printc("created sym link %s" % pack_path, 'g')

def install_node():
    """install Node.js to ~/opt/node.

    """

    node_dir = path.join(home, 'opt', 'node')
    if path.exists(node_dir):
        return

    import io, tarfile, requests
    major, minor, patch = 10, 15, 3
    name = "node-v{}.{}.{}-linux-x64".format(major, minor, patch)
    print("Downloading", name)
    url = "https://nodejs.org/download/release/latest-v{}.x/{}.tar.xz".format(
            major, name)
    res = requests.get(url)
    stream = io.BytesIO(res.content)
    with tarfile.open(fileobj=stream, mode='r:xz') as tar:
        tar.extractall(path=path.join(home, 'opt'))
    os.symlink(path.join(home, 'opt', name), node_dir)

def install_go():
    """install Golang to ~/opt/go.

    """

    go_dir = path.join(home, 'opt', 'go')
    if path.exists(go_dir):
        return

    import io, tarfile, requests
    major, minor, patch = 1, 12, 4
    name = "go{}.{}.{}.linux-amd64".format(major, minor, patch)
    print("Downloading", name)
    url = "https://dl.google.com/go/{}.tar.gz".format(name)
    res = requests.get(url)
    stream = io.BytesIO(res.content)
    with tarfile.open(fileobj=stream, mode='r:gz') as tar:
        tar.extractall(path=path.join(home, 'opt'))

files_linux = [
        (r".vimrc", r"vimrc"),
        (r".gvimrc", r"gvimrc"),
        (r".vim", r"vim"),
        (r".ideavimrc", r"ideavimrc"),
        (r".inputrc", r"inputrc"),
        (r".tmux.conf", r"tmux.conf"),
        (r".tmux/plugins", r"tmux/plugins"),
        (r".fzf", r"apps/fzf"),
        (r".pyenv", r"apps/pyenv"),
        (r".ctags", r"ctags"),
        (r".gitignore_global", r"gitignore_global"),
        (r".agignore", r"agignore"),
        (r".latexmkrc", r"latexmkrc"),
        (r".ocamlinit", r"ocamlinit"),
        (r".utoprc", r"utoprc"),
        (r".lambda-term-inputrc", r"lambda-term-inputrc"),
        (r".config/matplotlib/matplotlibrc", r"matplotlibrc"),
        (r".ipython/profile_default/ipython_config.py", r"ipython_config.py"),
        (r".ipython/profile_default/startup/ipython_startup.py", r"ipython_startup.py"),
        (r".config/gtk-3.0/gtk.css", r"gnome/gtk.css"),
        (r".config/i3/config", r"i3config"),
        (r".Xresources", r"Xresources"),
        ]

def unlink_linux():
    for f in files_linux:
        ln = path.join(home, f[0])
        if path.islink(ln):
            os.remove(ln)
            printc("[WARN] removed {}".format(ln), 'y')
        else:
            print("[INFO] {} doesn't exist".format(ln))

def link_linux(args):
    dirs = [r".tmux", r".config/matplotlib",
            r".ipython/profile_default/startup", r".local/tmp",
            r".config/gtk-3.0",
            r".config/i3",
            ]

    printc('[dirs]', 'b')
    for d in dirs:
        dn = path.join(home, d)

        if path.exists(dn):
            print("[INFO] already exists: %s" % dn)
        else:
            os.makedirs(dn)
            printc("created dir %s" % dn, 'g')

    printc('[links]', 'b')
    for f in files_linux:
        ln = path.join(home, f[0])
        tgt = path.join(home, 'dotfiles', f[1])

        if path.exists(ln):
            print("[INFO] already exists: %s" % ln)
        else:
            os.symlink(tgt, ln)
            printc("created sym link %s" % ln, 'g')

def main_linux(args):
    if args.uninstall:
        printc('[remove links]', 'r')
        unlink_linux()
        return

    printc('[make dirs and links]', 'b')
    link_linux(args)
    printc('[git global config]', 'b')
    set_git_global_config()

    if args.all or args.apt:
        printc('[apt packages]', 'b')
        install_apt_packages(args.upgrade)

    # shell and fzf should be later than apt.
    printc('[shell]', 'b')
    setup_shell()
    printc('[fzf]', 'b')
    setup_fzf()

    # language package managers
    import __main__
    for pack in ('pip', 'gem', 'opam'):
        if args.all or getattr(args, pack):
            printc('[{} packages]'.format(pack), 'b')
            getattr(__main__, 'install_{}_packages'.format(pack))(args.upgrade)

    # languages
    for lang in ('node', 'go'):
        if args.all or getattr(args, lang):
            printc('[{}]'.format(lang), 'b')
            getattr(__main__, 'install_{}'.format(lang))()

    # vim should be last because some package manager installs vim plugin.
    # e.g. merlin by opam.
    if args.all or args.vim:
        printc('[vim]', 'b')
        setup_vim()

def parse_args():
    parser = argparse.ArgumentParser(description='Install my dotfiles etc.')
    parser.add_argument('--uninstall', action='store_true',
            help='Uninstall by removing links. Other options are ignored.')
    parser.add_argument('-U', '--upgrade', action='store_true',
            help='Upgrade packages etc.')
    parser.add_argument('-v', '--vim', action='store_true',
            help='Build vim and generate helptags for plugins.')
    parser.add_argument('-A', '--all', action='store_true',
            help='Install all extra things. e.g. packages.')
    parser.add_argument('-a', '--apt', action='store_true',
            help='Install apt packages.')
    parser.add_argument('-p', '--pip', action='store_true',
            help='Install pip packages.')
    parser.add_argument('-g', '--gem', action='store_true',
            help='Install gem packages.')
    parser.add_argument('-o', '--opam', action='store_true',
            help='Install opam packages.')
    parser.add_argument('-G', '--go', action='store_true',
            help='Install Golang.')
    parser.add_argument('-n', '--node', action='store_true',
            help='Install Node.js.')

    return parser.parse_args()

if __name__ == '__main__':
    args = parse_args()

    if osname == 'Windows':
        main_windows(args)
    elif osname == 'Linux' and distname == 'Ubuntu' or distname == 'Debian':
        main_linux(args)
    else:
        raise NotImplementedError("OS %s is not supported." % osname)

