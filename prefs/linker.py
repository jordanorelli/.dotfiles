import pathlib

from . import host

class Linker:
    """
    Linker links files from soome source to some target
    """
    def __init__(self, source_root, target_root):
        self.source_root = source_root
        self.target_root = target_root

    def link(self, source_path, target_path):
        if not source_path.is_absolute():
            source_path = self.source_root / source_path
        if not target_path.is_absolute():
            target_path = self.target_root / target_path

        if not target_path.parent.exists():
            print("creating missing parent directories for target")
            parent_dir = target_path.parent
            parent_dir.mkdir(parents=True)

        print(f"{source_path} -> {target_path}")

class LinkFiles:
    resource_name = 'link-files'

    def __init__(self, label, section):
        self.label = label
        self.target_root = pathlib.Path(section['target_root']).expanduser()
        self.source_root = host.dotfiles_root
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
            return f'<LinkFiles: {self.label}>'
        return '<LinkFiles>'

    def run(self):
        linker = Linker(host.dotfiles_root, self.target_root)
        for pair in self.files:
            source_path = pathlib.Path(pair[0])
            target_path = pathlib.Path(pair[1])
            linker.link(source_path, target_path)
