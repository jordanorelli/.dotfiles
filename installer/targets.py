"""
defines target classes: the places where things should be written
"""

import pathlib
import subprocess
import shutil
import os
from functools import cached_property

from installer import host

class Target:
    """
    base class of all target platforms
    """
    def target_path(self, relpath):
        """
        computes the path of a file in the home directory
        """
        return self.target_root / relpath

    @cached_property
    def target_root(self):
        """
        locates the home directory
        """
        return pathlib.Path.home()

    def map_file(self, source_path, target_path):
        """
        maps a file from a source path to some target path. The source path is
        expected to be an absolute path, while the target_path is a relative
        path, relative to the target's root.
        """
        if not target_path.is_absolute():
            target_path = self.target_root / target_path

        print(f"target path: {target_path}")
        print(f"target drive: {target_path.drive}")
        if not target_path.parent.exists():
            print("creating missing parent directories for target")
            parent_dir = target_path.parent
            parent_dir.mkdir(parents=True)

        print(f"checking if target path {target_path.parts} exists")
        exists = os.path.exists(str(target_path))
        print(f"exists: {exists}")
        is_link = os.path.islink(str(target_path))
        print(f"is link: {is_link}")
        if target_path.exists():
            print("target path exists")
            if target_path.is_symlink():
                print("target path is symlink")
                if target_path.resolve() == source_path:
                    print("symlink is up to date")
                    return
                print("removing out of date symlink")
                target_path.unlink()
            elif target_path.is_file():
                print("removing existing regular file")
                target_path.unlink()
            elif target_path.is_dir():
                print("skip: target path is existing directory")
                return
            else:
                print("skip: target path already exists")
                return
        else:
            print("target path does not exist")
            if target_path.is_symlink():
                # ok this deserves some explaining: if a symlink points to
                # itself, then pathlib considers it to not exist. It can't be
                # resolved because it's an infinite loop, but a non-existent
                # file that is a symlink is a circular reference in a symlink.
                print("removing broken symlink")
                target_path.unlink()
        print("creating symlink")
        target_path.symlink_to(source_path)

class Linux(Target):
    """
    defines a local Linux target: the local machine when the script is run on
    Linux
    """

class Windows(Target):
    """
    defines a local Windows target: the local machine when the script is run on
    Windows
    """

class WSLHost(Target):
    """
    defines the Windows machine on which the WSL instance is hosted
    """
    @cached_property
    def target_root(self):
        if not host.is_wsl:
            raise Exception("cannot get windows home dir from anything other than wsl")
        res = subprocess.run(['wslvar', 'USERPROFILE'], check=False,
                capture_output=True)
        winpath = res.stdout.decode('utf-8').strip()
        res = subprocess.run(['wslpath', winpath], check=False,
                capture_output=True)
        return pathlib.Path(res.stdout.decode('utf-8').strip())

    def map_file(self, source_path, target_path):
        """
        maps a file from a source path to some target path. The source path is
        expected to be an absolute path, while the target_path is a relative
        path, relative to the target's root.
        """
        if source_path.is_file():
            clone = shutil.copy
        elif source_path.is_dir():
            clone = shutil.copytree
        else:
            print(f"source path {source_path} is not a file or directory")
            return

        if not target_path.is_absolute():
            target_path = self.target_root / target_path

        print(f"target path: {target_path}")
        print(f"target drive: {target_path.drive}")
        if not target_path.parent.exists():
            print("creating missing parent directories for target")
            parent_dir = target_path.parent
            parent_dir.mkdir(parents=True)

        print(f"checking if target path {target_path.parts} exists")
        exists = os.path.exists(str(target_path))
        print(f"exists: {exists}")
        is_link = os.path.islink(str(target_path))
        print(f"is link: {is_link}")
        if target_path.exists():
            print("target path exists")
            if target_path.is_file():
                print("removing existing regular file")
                target_path.unlink()
            else:
                print("skip: target path exists and is not a regular file")
                return
        else:
            print("target path does not exist")
        print("copying file to target")
        clone(source_path, target_path)
