import subprocess
from pathlib import Path
from . import log

class Repo:
    resource_name = 'git'

    def __init__(self, label, section):
        self.label = label or None
        self.repo = section['repo']
        self.target = Path(section['target']).expanduser()

    def run(self):
        if self.target.exists():
            log.debug("target exists")
            if self.target.is_dir():
                log.debug("target is dir")
                git_dir = self.target / ".git"
                if git_dir.exists() and git_dir.is_dir():
                    log.debug("target is git repo")
                    return

        cmd = ["git", "clone", self.repo, self.target]
        subprocess.call(cmd)
