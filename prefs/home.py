class Home:
    def __init__(self, label = None):
        self.label = label

    @classmethod
    def from_name(cls, name):
        """
        Builds a Home struct from a given name
        """
        if name.startswith('home'):
            label = name.removeprefix('home').strip()
            return cls(label)
        return None

    def parse_section(self, section):
        mapping = {
            'files': self.parse_files
        }
        for key in section:
            if fn := mapping.get(key):
                val = section[key]
                fn(val)
            else:
                raise KeyError(f"Home has no such config key: {key}")

    def parse_files(self, text):
        lines = [s for s in text.splitlines() if s]
        print(f"      parse_files: {lines}")

    def __repr__(self):
        if self.label:
            return f'<Home: {self.label}>'
        return '<Home>'
