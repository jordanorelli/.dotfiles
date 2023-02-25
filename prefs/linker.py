import pathlib
import shutil
import os

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
            print(f"mkdir -p {target_path.parent}")
            parent_dir = target_path.parent
            parent_dir.mkdir(parents=True)

        exists = os.path.exists(str(target_path))
        is_link = os.path.islink(str(target_path))
        if target_path.exists():
            if target_path.is_symlink():
                if target_path.resolve() == source_path:
                    return
                print(f"rm {target_path} (symlink)")
                target_path.unlink()
            elif target_path.is_file():
                print(f"rm {target_path} (file)")
                target_path.unlink()
            elif target_path.is_dir():
                print(f"rm {target_path} (dir)")
                shutil.rmtree(target_path)
            else:
                print(f"skip {source_path}: unable to handle target at {target_path}: is not a symlink, file, or directory")
                return
        else:
            if target_path.is_symlink():
                print(f"rm {target_path} (broken symlink)")
                target_path.unlink()

        target_path.symlink_to(source_path)
        print(f"link {target_path} -> {source_path}")

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
