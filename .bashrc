# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth
# never truncate bash history file
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# always write a history line
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color)
        color_prompt=yes
        ;;
    xterm-kitty)
        # the kitty docs recommend not changing the TERM value, so, we'll try
        # that until it breaks.
        color_prompt=yes
        ;;
esac

# uncomment for a colored prompt, if the terminal has the capability
force_color_prompt=yes

export PS1="\[\e[0;32m\]\u@\h[\j] \w: \[\e[m\]"

export EDITOR=vim

case $( uname -s ) in
Darwin)
    echo "Using OSX bash settings."
    alias ls="ls -G"
    ;;
Linux)
    # for some reason I find this welcome string more annoying on Linux
    ;;
MSYS_NT-10.0-22000)
    # I don't actually have any MSYS-specific settings yet but probably will at
    # some point
    echo "Using MSYS bash settings."
    ;;
*)
    echo "No platform-specific bash settings are enabled."
    ;;
esac

alias tree="tree -C"
alias ls="ls --color=auto"

if [ -f "$HOME/.localrc" ]; then
    echo "Using machine-specific settings from "$HOME/.localrc""
    source "$HOME/.localrc"
fi

alias randompass="python -c \"import string, random; print ''.join(random.sample(string.letters+string.digits, 8))\""

if [ -d "$HOME/.dotfiles" ]; then
    alias dotfiles="$HOME/.dotfiles/install.sh"
fi

# if kitty is installed, register its completions
if command -v kitty &> /dev/null
then
    source <(kitty + complete setup bash)
fi

# sometimes I just put binary files in a bin dir in my home directory. Is this
# gross? I dunno. What are you, some kind of cop?
if [ -d "$HOME/bin" ]; then
    export PATH="$PATH:$HOME/bin"
fi

if [ -d "$HOME/.local/bin" ]; then
    export PATH="$PATH:$HOME/.local/bin"
fi

# add the Go bindir to the path if we have the standard Go install dir
if [ -d /usr/local/go ]; then
    export PATH=$PATH:$HOME/go/bin:/usr/local/go/bin
fi

if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi
