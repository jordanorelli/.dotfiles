from .home import Home

class Resource:
    resource_types = [Home]

    @classmethod
    def from_name(cls, name):
        """
        from_name is to be implemented by resource classes
        """
        for T in cls.resource_types:
            if r := T.from_name(name):
                return r
        return None

    def when(self, when_text):
        pass
