"""
a logging object
"""

import logging
import sys

class Log:
    def __init__(self):
        logging.basicConfig(level=logging.INFO, format='')
        self._target = logging.getLogger()

    def __getattr__(self, name):
        return getattr(self._target, name)

    def __dir__(self):
        return dir(self._target)

sys.modules[__name__] = Log()
