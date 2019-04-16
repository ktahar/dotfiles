#!/usr/bin/env python3

import sys
import os
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

    [bubblewrap]
    required by OPAM 2.0.
    While Ubuntu 18.04+ has apt package for this,
    Ubuntu 16.04 doesn't. So, build from source.

    """

    # fzf
    fzf_install = [os.path.join(home, '.fzf/install'),
            '--key-bindings',
            '--completion',
            '--no-update-rc',
            '--no-bash']
    subprocess.run(fzf_install)

    # bubblewrap
    e_local_bwrap = os.path.exists(os.path.join(home, ".local", "bin", "bwrap"))
    if osname == 'Linux' and distid == 'xenial' and not e_local_bwrap:
        wd = os.path.join(home, "dotfiles", "apps", "bubblewrap")
        subprocess.run(['./autogen.sh'], cwd=wd)
        subprocess.run(['./configure', '--prefix={}/.local'.format(home)], cwd=wd)
        subprocess.run(['make'], cwd=wd)
        subprocess.run(['install', '-c', 'bwrap', "{}/.local/bin".format(home)],
                cwd=wd)

    # vim
    ## check commit hash of HEAD
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

    subprocess.run([os.path.join(local_bin, 'pip2')] + opts + pkgs + pkgs_2)
    subprocess.run([os.path.join(local_bin, 'pip3')] + opts + pkgs + pkgs_3)

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

    """

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

    opam = os.path.join(home, ".local", "bin", "opam")
    if not os.path.exists(opam):
        install_opam(opam)

    if not os.path.exists(os.path.join(home, '.opam')):
        subprocess.run([opam, 'init'])
        printc("[WARN] opam init is done but opam install is skipped. type eval $(opam env), and run install.py -o again.", 'y')
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
        pkg_path = os.path.join(opam_share, pkg, 'vim')
        pack_path = os.path.join(home, 'dotfiles',
                'vim', 'pack', 'my', 'start', pkg)
        if not os.path.exists(pack_path):
            os.symlink(pkg_path, pack_path)
            printc("created sym link %s" % pack_path, 'g')

    ## generate helptags for merlin.
    doc_path = os.path.join(opam_share, 'merlin', 'vim', 'doc')
    subprocess.run(['vim', '-c', 'helptags ' + doc_path, '-c', 'quit'])

def install_node():
    """install Node.js to ~/opt/node.

    """

    node_dir = os.path.join(home, 'opt', 'node')
    if os.path.exists(node_dir):
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
        tar.extractall(path=os.path.join(home, 'opt'))
    os.symlink(os.path.join(home, 'opt', name), node_dir)

def install_go():
    """install Golang to ~/opt/go.

    """

    go_dir = os.path.join(home, 'opt', 'go')
    if os.path.exists(go_dir):
        return

    import io, tarfile, requests
    major, minor, patch = 1, 12, 4
    name = "go{}.{}.{}.linux-amd64".format(major, minor, patch)
    print("Downloading", name)
    url = "https://dl.google.com/go/{}.tar.gz".format(name)
    res = requests.get(url)
    stream = io.BytesIO(res.content)
    with tarfile.open(fileobj=stream, mode='r:gz') as tar:
        tar.extractall(path=os.path.join(home, 'opt'))

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
        ]

def unlink_linux():
    for f in files_linux:
        ln = os.path.join(home, f[0])
        if os.path.islink(ln):
            os.remove(ln)
            printc("[WARN] removed {}".format(ln), 'y')
        else:
            print("[INFO] {} doesn't exist".format(ln))

def link_linux(args):
    dirs = [r".tmux", r".config/matplotlib",
            r".ipython/profile_default/startup", r".local/tmp",
            r".config/gtk-3.0"]

    printc('[dirs]', 'b')
    for d in dirs:
        dn = os.path.join(home, d)

        if os.path.exists(dn):
            print("[INFO] already exists: %s" % dn)
        else:
            os.makedirs(dn)
            printc("created dir %s" % dn, 'g')

    printc('[links]', 'b')
    for f in files_linux:
        ln = os.path.join(home, f[0])
        tgt = os.path.join(home, 'dotfiles', f[1])

        if os.path.exists(ln):
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
    printc('[vimrc local]', 'b')
    copy_vimrc_local()
    printc('[git global config]', 'b')
    set_git_global_config()

    if args.all or args.apt:
        printc('[apt packages]', 'b')
        install_apt_packages(args.upgrade)

    # shell and apps should be later than apt.
    printc('[shell]', 'b')
    setup_shell()
    printc('[apps]', 'b')
    setup_apps()

    # language package managers
    import __main__
    for pack in ('pip', 'gem', 'opam'):
        if args.all or getattr(args, pack):
            printc('[{} packages]'.format(pack), 'b')
            getattr(__main__, 'install_{}_packages'.format(pack))(args.upgrade)
    for lang in ('node', 'go'):
        if args.all or getattr(args, lang):
            printc('[{}]'.format(lang), 'b')
            getattr(__main__, 'install_{}'.format(lang))()

def parse_args():
    parser = argparse.ArgumentParser(description='Install my dotfiles etc.')
    parser.add_argument('--uninstall', action='store_true',
            help='Uninstall by removing links. Other options are ignored.')
    parser.add_argument('-U', '--upgrade', action='store_true',
            help='Upgrade packages etc.')
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

