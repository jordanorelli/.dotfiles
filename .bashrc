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
*)
    echo "No platform-specific bash settings are enabled."
    ;;
esac

alias tree="tree -C -I vendor"
alias ls="ls --color=auto"

if [ -f "$HOME/.localrc" ]; then
    source "$HOME/.localrc"
fi

alias randompass="python -c \"import string, random; print ''.join(random.sample(string.letters+string.digits, 8))\""
alias dotfiles="$HOME/.dotfiles/install.sh"
