from . import host
from .linker import Linker

class Home:
    resource_name = 'home'

    def __init__(self, label, section):
        self.label = label or None
        self.parse_files(section.get('files', ''))

    def parse_files(self, text):
        self.files = []
        lines = [s for s in text.splitlines() if s]
        for line in lines:
            parts = line.split(">", 2)
            if len(parts) == 1:
                pair = (parts[0].strip(), parts[0].strip())
            else:
                pair = (parts[0].strip(), parts[1].strip())
            self.files.append(pair)

    def __repr__(self):
        if self.label:
            return f'<Home: {self.label}>'
        return '<Home>'

    def run(self):
        linker = Linker(host.dotfiles_root, host.home)
        for pair in self.files:
            source_path = host.dotfiles_root / pair[0]
            target_path = host.home / pair[1]
            linker.link(source_path, target_path)
