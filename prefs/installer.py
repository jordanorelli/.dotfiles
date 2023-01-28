import pathlib
import sys
import json
from functools import cached_property

from . import host
from . import sections
from . import targets
from .options import Options

class Installer:
    """
    manages the installation of preferences files
    """
    def __init__(self):
        self.options = Options.from_cli_args()

    def run(self):
        """
        runs the install process
        """
        if host.is_windows and not host.is_admin:
            print("You are not admin: admin is required on Windows")
            sys.exit(1)

        config = self.options.config
        for section_name in config.sections():
            try:
                T = self.parse_section_name(section_name)
            except ValueError as e:
                print(f"error reading section: {e}")
                continue
            section = T.from_section(section_name, **config[section_name])
            print(f"Section: {section}")
            section.run()

        print("linking in home files")
        home = self.options.config['home']
        home_files = filter(None, home['files'].splitlines())
        for fname in home_files:
            print(f"\n{fname}")
            path = pathlib.Path(fname)
            self.map_file(path, path)

        if host.is_linux:
            self.map_section('map.posix')
            self.map_section('map.windows')

        if host.is_windows:
            self.map_section('map.windows')

    @cached_property
    def targets(self):
        """
        defines all of the places where preferences files will be installed
        """
        if host.is_linux:
            return [targets.Linux()]

        if host.is_windows:
            return [targets.Windows()]

        return []

    def map_file(self, source_path, target_path):
        if not source_path.is_absolute():
            source_path = host.dotfiles_root / source_path

        print(f"source path: {source_path}")
        print(f"source drive: {source_path.drive}")
        if not source_path.exists():
            print("skip: no such file\n")
            return

        for target in self.targets:
            target.map_file(source_path, target_path)

    @property
    def config_path(self):
        # pylint: disable=missing-function-docstring
        return self.options.config

    @cached_property
    def config(self):
        """
        the contents of our configuration file
        """
        with open(self.config_path, 'r', encoding='utf-8') as config_fp:
            log.debug("loading config from path %s", self.config_path)
            return json.load(config_fp)

    def map_section(self, section_name):
        section = self.options.config[section_name]
        for source_name in section:
            target_name = section[source_name]
            source_path = pathlib.Path(source_name)
            target_path = pathlib.Path(target_name)
            print(f"Map {source_path} to {target_path}")
            self.map_file(source_path, target_path)

    def parse_section_name(self, section_name):
        if section_name == "home":
            return sections.Home
        raise ValueError(f"unprocessable section name: {section_name}")

