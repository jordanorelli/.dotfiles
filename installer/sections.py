"""
sections defines our various config sections
"""

import pathlib

class Home:
    """
    the [home] section maps files within the home directory
    """
    @classmethod
    def from_section(Cls, name, **section):
        v = Cls()
        if raw_files := section.get('files'):
            v.files = filter(None, raw_files.splitlines())
        else:
            v.files = None
        return v

    def run(self):
        pass

