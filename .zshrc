#Prompt and colors
function parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[󰊢 \1] /p'
}
autoload -U colors && colors	# Load colors
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
PROMPT='%f%F{cyan}%n%f %F{blue}%~ %f%F{magenta}$(parse_git_branch)%f%F{red}>'
#PROMPT="%B%{$fg[red]%}[%{$fg[cyan]%}%n%{$fg[red]%}@%{$fg[purple]%}%M %{$fg[magenta]%}%~%{$vcs_info_msg_0_[red]%}%{$fg[red]%}]%{$reset_color%}$%b "
#History
HISTSIZE=1000000000
SAVEHIST=1000000000
HISTFILE="$HOME/.cache/zsh/history"

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

#Themes
#VI keybindings
bindkey -v
export KEYTIMEOUT=1

#VI keybindings for autocomplete
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}


zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

#
alias \
 ls="ls --color=auto" \
 cls='clear' \
 vim="nvim"   \
 ll='ls -lah' \
 token='pass show github_token | xclip -selection clipboard;echo Password copied successfully' \
 notes="nvim ~/Documents/notes" \
 pp="cd ~/Public/Projects;ls" \
 rp="cd ~/Public/Ref-Projects;ls" \
 dsa="cd ~/Public/90_Days_of_DSA;ls"\
 scratch="cd ~/Scratchpad;ls"\
 aoco="cd ~/Public/Advent_of_Code;ls"\
 learn="cd ~/Public/Learning;ls" \
 cf="cd ~/.config;ls"   \
 skill="cd ~/Public/90_Days_of_DSA/SkillRack;ls"\
 ff="cd \$(fzf -i | rev | cut -d '/' -f 2- | rev);ls" \
 src='cd ~/.local/source;ls' \
 bin='cd ~/.local/bin;ls' \

#Auto Completion
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

#Syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#startx when loggedin
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
  exec startx &>/dev/null
fi


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

export EDITOR="nvim"
# golang path
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin


# bun completions
[ -s "/home/sanj/.bun/_bun" ] && source "/home/sanj/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
