#Prompt and colors
function parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[󰊢 \1] /p'
}
autoload -U colors && colors	# Load colors
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
PROMPT='%f%F{#81a1c1}%n%f %F{#d8dee9}%~ %f%F{#a1baf0}$(parse_git_branch)%f%F{#eceff4}>'
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

alias sd="setxkbmap us -v dvorak"
alias sq="setxkbmap us"

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
#Auto Completion (dim ghost-text for suggestions)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax highlighting: Nordic blue (256-color)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[default]='fg=252'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=203'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=110'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=110'
ZSH_HIGHLIGHT_STYLES[command]='fg=117'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=117'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=110'
ZSH_HIGHLIGHT_STYLES[function]='fg=110'
ZSH_HIGHLIGHT_STYLES[alias]='fg=117'
ZSH_HIGHLIGHT_STYLES[path]='fg=252'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=110'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=243'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=243'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=243'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=110'
ZSH_HIGHLIGHT_STYLES[comment]='fg=242'
ZSH_HIGHLIGHT_STYLES[assign]='fg=117'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=243'
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#startx when loggedin
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
  exec startx &>/dev/null
fi

source ~/.config/zsh/envs
source ~/.config/zsh/aliases

# opencode
export PATH="$HOME/.opencode/bin:$PATH"
