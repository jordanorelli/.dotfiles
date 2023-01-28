"""
host module represents our host: the machine on which the installer script is
running. On WSL, that means we're on Linux
"""

import ctypes
import os
import platform
import sys
import pathlib
from functools import cached_property

class _Host:
    """
    hacking the python module system a little to make the module look like a
    singleton object so that it can have properties
    """
    @cached_property
    def is_wsl(self):
        """
        true if we're running Linux on WSL
        """
        return 'WSL2' in platform.platform()

    @cached_property
    def is_linux(self):
        """
        true if we're on linux (including WSL), false otherwise
        """
        return platform.system() == 'Linux'

    @cached_property
    def is_windows(self):
        """
        true if we're on Windows (and running Python from Windows)
        """
        return platform.system() == 'Windows'

    @cached_property
    def is_admin(self):
        """
        tells us whether the running user has admin powers or not
        """
        try:
            return os.getuid() == 0
        except AttributeError:
            return ctypes.windll.shell32.IsUserAnAdmin() != 0

    @property
    def dotfiles_root(self):
        """
        directory containing our preferences repo
        """
        here = pathlib.Path(os.path.realpath(__file__))
        return here.parent.parent


sys.modules[__name__] = _Host()
