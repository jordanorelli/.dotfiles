"""
just exists to define our installer
"""

import argparse
import json
import os
import pathlib
import platform
import subprocess
import shutil
from functools import cached_property

from installer import host
from installer.options import Options
from installer import log

def install():
    """
    runs our install process based on cli arguments
    """
    installer = Installer()
    installer.run()

class Installer:
    """
    manages the installation of preferences files
    """
    def __init__(self):
        self.options = Options.from_cli_args()
        self.config_path = "include.json"

    def run(self):
        """
        runs the install process
        """
        if home_files := self.config.get('home_files'):
            for name in home_files:
                self.install_home_file(name)

    def install_home_file(self, name):
        """
        installs a given file
        """
        log.debug("install: %s", name)

        source_path = self.prefs_dir / name
        log.debug("  source: %s", source_path)
        if not source_path.exists():
            log.warning("home file source path %s does not exist", source_path)
            return

        if not source_path.is_file():
            log.warning("home file source path %s is not a file", source_path)
            return

        if host.is_linux:
            target_path = pathlib.Path.home() / name
            log.debug("  target: %s", target_path)
            if target_path.exists():
                log.debug("    target path exists, will remove")
                target_path.unlink()
            log.debug("    link: %s -> %s", target_path, source_path)
            target_path.symlink_to(source_path)

        if host.is_wsl:
            target_path = self.windows_home_dir / pathlib.PureWindowsPath(name)
            log.debug("  target: %s", target_path)
            if target_path.exists():
                log.debug("    target path exists, will remove")
                target_path.unlink()
            log.debug("    copy: %s -> %s", source_path, target_path)
            shutil.copy(source_path, target_path)

    @cached_property
    def config(self):
        """
        loads the json configuration
        """
        with open(self.config_path, 'r', encoding='utf-8') as config_fp:
            log.debug("loading config from path %s", self.config_path)
            return json.load(config_fp)

    @property
    def prefs_dir(self):
        """
        directory containing our preferences repo
        """
        here = pathlib.Path(os.path.realpath(__file__))
        return here.parent.parent

    @cached_property
    def windows_home_dir(self):
        """
        Finds the home directory of the user's Windows home directory and
        returns it as a Posix path representing its mount point from the
        perspective of WSL.
        """
        if not host.is_wsl:
            raise Exception("cannot get windows home dir from anything other than wsl")
        res = subprocess.run(['wslvar', 'USERPROFILE'], check=False,
                capture_output=True)
        winpath = res.stdout.decode('utf-8').strip()
        res = subprocess.run(['wslpath', winpath], check=False,
                capture_output=True)
        return pathlib.Path(res.stdout.decode('utf-8').strip())

    def setup_file(self, fname):
        """
        sets up an individual file
        """
        source = self.prefs_dir / fname
        print(source)
