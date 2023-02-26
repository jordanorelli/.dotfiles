import subprocess
import shutil
import re

class CargoInstall:
    resource_name = 'cargo-install'

    def __init__(self, label, section):
        self.label = label or None
        self.parse_crates(section.get('crates', ''))

    def run(self):
        if shutil.which('cargo') is None:
            print(f"skip [cargo-install {self.label}]: cargo not found")

        if missing := self.crates - self.installed:
            print(f"installing missing cargo binaries: {missing}")
            cmd = ["cargo", "install"]
            cmd.extend(list(missing))
            with subprocess.Popen(cmd, stdout=subprocess.PIPE) as proc:
                print(proc.stdout.read())

    def parse_crates(self, text):
        self.crates = set()
        for line in text.splitlines():
            if not line:
                continue
            crate = line.strip()
            self.crates.add(crate)

    @property
    def installed(self):
        cmd = ["cargo", "install", "--list"]
        found = set()
        p = subprocess.run(cmd, capture_output=True, check=True)
        for line in p.stdout.splitlines():
            if not line:
                # line is empty
                continue
            line = line.decode("utf-8")
            if re.match(r'^\s', line):
                # line starts with whitespace
                continue
            try:
                item = line.split()[0]
                found.add(item)
            except IndexError:
                continue
        return found
