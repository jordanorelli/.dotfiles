"""
cli options
"""

import argparse
import configparser
import pathlib

from installer import log, host

class Options:
    """
    turns the cli arguments into an object with nice fields and the like
    """
    @classmethod
    def from_cli_args(cls):
        """
        creates an options object by parsing the command-line
        """
        parser = argparse.ArgumentParser(
                prog = 'install',
                description = """
                installs preferences files. This is designed to work on a bunch
                of different systems, and can manage Windows preferences from
                WSL.
                """)
        parser.add_argument('-v', '--verbose', action='store_true')
        parser.add_argument('-q', '--quiet', action='store_true')
        parser.add_argument('-c', '--config', help="path to config file")
        options = cls()
        parser.parse_args(namespace=options)

        if options.quiet:
            log.setLevel(50)

        if options.verbose:
            log.setLevel(10)

        return options

    @property
    def quiet(self):
        # pylint: disable=missing-function-docstring
        return self._quiet

    @quiet.setter
    def quiet(self, val):
        self._quiet = val

    @property
    def verbose(self):
        # pylint: disable=missing-function-docstring
        return self._verbose and not self._quiet

    @verbose.setter
    def verbose(self, val):
        self._verbose = val

    @property
    def config(self):
        # pylint: disable=missing-function-docstring
        return self._config

    @config.setter
    def config(self, val):
        if val is None:
            path = host.dotfiles_root / "config.ini"
        else:
            path = pathlib.Path(val)

        with open(path, 'r', encoding='utf-8') as config_file:
            parser = configparser.ConfigParser()
            parser.read_file(config_file)
            self._config = parser
