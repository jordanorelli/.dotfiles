# dotfiles

my preferences files

## setup

The way this repo is setup is that the .dotfiles directory is expected to be
the authoritative storage of all of the preferences file on a given machine.
The `install` script creates the necessary symlinks for these preference files
to be seen by the appropriate applications.

## sharing between WSL and Windows

If you want to use this repo to manage the preferences file of both a WSL
instance and its Windows host, clone this repo on WSL and then symlink the
directory into the home directory of the Windows host like so:

    C:\Users\Name>mklink /D .dotfiles \\wsl$\instance\home\name\.dotfiles

You can then navigate into the Linux directory from Windows, either on the
command line or in Explorer.exe. Using an administrator shell, run the install
script from the Windows side. Windows requires admin privileges in order to
make symbolic links, so you need an admin shell to register new links on
Windows.
