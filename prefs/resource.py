from .home import Home
from .linker import LinkFiles
from .cargo import CargoInstall
from .run import Run
from . import git

class Resource:
    resource_types = [Home, LinkFiles, CargoInstall, Run, git.Repo]

    @classmethod
    def from_name(cls, name):
        """
        from_name is to be implemented by resource classes
        """
        for T in cls.resource_types:
            if T.resource_name == name:
                return T
        raise ValueError(f"No section type has name {name}")

    @classmethod
    def from_section(cls, name, section):
        parts = name.split(' ')
        name = parts[0]
        try:
            label = parts[1]
        except IndexError:
            label = None
        T = cls.from_name(name)
        return T(label, section)
