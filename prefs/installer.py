import configparser
import json
import pathlib
import sys
from functools import cached_property

from . import host
from . import sections
from . import targets
from .options import Options
from .resource import Resource

class Installer:
    """
    manages the installation of preferences files
    """
    def __init__(self):
        self.options = Options.from_cli_args()

    @cached_property
    def config(self):
        path = self.options.config_path
        with open(path, 'r', encoding='utf-8') as config_file:
            parser = configparser.ConfigParser()
            # make keys case-sensitive
            parser.optionxform = str
            parser.read_file(config_file)
            return parser

    def run(self):
        resources = []
        for name in self.config.sections():
            section = self.config[name]
            if self.when(section):
                r = Resource.from_section(name, section)
                resources.append(r)
        for r in resources:
            r.run()

    def when(self, section):
        if clause := section.get('when', None):
            return eval(clause)
        return True
