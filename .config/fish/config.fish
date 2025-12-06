set fish_color_command green --bold --underline
set fish_color_keyword white --italics
set fish_color_normal white 
set fish_color_error red --bold

alias ll='eza -lh --icons --group-directories-first'
alias la='eza -a --icons --group-directories-first'
alias l='eza --icons --group-directories-first'
alias ls='eza --icons --group-directories-first'
alias lla='eza -lha --icons --group-directories-first'
alias tree="eza -T --icons --group-directories-first"

alias cat='bat --style=plain --paging=never'

alias cd='z'

alias grep="grep --color=auto"
alias v='nvim'

alias gs='git status -s'
alias ga='git add'
alias gc='git commit'
alias gcm='git commit -m '
alias gl='git log --oneline'
alias gp='git push'

alias zr='source ~/.config/fish/config.fish'

zoxide init fish | source
starship init fish | source
