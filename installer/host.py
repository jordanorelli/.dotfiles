"""
host module represents our host: the machine on which the installer script is
running. On WSL, that means we're on Linux
"""

import sys
import platform
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

sys.modules[__name__] = _Host()
