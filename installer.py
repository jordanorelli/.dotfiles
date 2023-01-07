"""
just exists to define our installer
"""

import argparse
import json
import logging
import os
import pathlib
import platform
import subprocess
import shutil

from functools import cached_property

class Installer:
    """
    manages the installation of preferences files
    """
    def __init__(self, quiet=False, verbose=False):
        log_level = logging.INFO
        if verbose:
            log_level = logging.DEBUG
        if quiet:
            log_level = logging.ERROR
        logging.basicConfig(level=log_level, format='')
        self.log = logging.getLogger('install')
        self.config_path = "include.json"

    @classmethod
    def from_cli_args(cls):
        """
        builds an installer from CLI arguments
        """
        args = cls.parse_cli()
        installer = cls(quiet=args.quiet, verbose=args.verbose)
        return installer

    @classmethod
    def parse_cli(cls):
        """
        parses our cli arguments
        """
        parser = argparse.ArgumentParser(
                prog = 'install',
                description = 'installs my preferences',
                epilog = 'this should work on a bunch of different environments')
        parser.add_argument('-v', '--verbose', action='store_true')
        parser.add_argument('-q', '--quiet', action='store_true')
        return parser.parse_args()

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
        self.log.debug("install: %s", name)

        source_path = self.prefs_dir / name
        self.log.debug("  source: %s", source_path)
        if not source_path.exists():
            self.log.warning("home file source path %s does not exist", source_path)
            return

        if not source_path.is_file():
            self.log.warning("home file source path %s is not a file", source_path)
            return

        if self.is_linux:
            target_path = pathlib.Path.home() / name
            self.log.debug("  target: %s", target_path)
            if target_path.exists():
                self.log.debug("    target path exists, will remove")
                target_path.unlink()
            self.log.debug("    link: %s -> %s", target_path, source_path)
            target_path.symlink_to(source_path)

        if self.is_wsl:
            target_path = self.windows_home_dir / pathlib.PureWindowsPath(name)
            self.log.debug("  target: %s", target_path)
            if target_path.exists():
                self.log.debug("    target path exists, will remove")
                target_path.unlink()
            self.log.debug("    copy: %s -> %s", source_path, target_path)
            shutil.copy(source_path, target_path)

    @cached_property
    def config(self):
        """
        loads the json configuration
        """
        with open(self.config_path, 'r', encoding='utf-8') as config_fp:
            self.log.debug("loading config from path %s", self.config_path)
            return json.load(config_fp)

    @property
    def prefs_dir(self):
        """
        directory containing our preferences repo
        """
        return pathlib.Path(os.path.dirname(os.path.realpath(__file__)))

    @classmethod
    @cached_property
    def is_linux(cls):
        """
        true if we're on linux (including WSL), false otherwise
        """
        return platform.system() == 'Linux'

    @classmethod
    @cached_property
    def is_wsl(cls):
        """
        true if we're running Linux on WSL
        """
        return 'WSL2' in platform.platform()

    @cached_property
    def windows_home_dir(self):
        """
        Finds the home directory of the user's Windows home directory and
        returns it as a Posix path representing its mount point from the
        perspective of WSL.
        """
        if not self.is_wsl:
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
