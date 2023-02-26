import subprocess
import os
import shutil
from . import host

class Run:
    resource_name = 'run'

    def __init__(self, label, section):
        self.label = label or None
        self.cmd = section.get('cmd', '').split()
        self.cwd = section.get('cwd', host.dotfiles_root)
        self.shell = section.get('shell', False)

    def run(self):
        kwargs = {
            "cwd": self.cwd,
            "stdout": subprocess.PIPE,
            "text": True,
            "shell": self.shell,
        }
        with subprocess.Popen(self.cmd, **kwargs) as proc:
            line = proc.stdout.read()
            if line:
                print(line)
