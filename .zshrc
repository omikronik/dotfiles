export PATH="/opt/homebrew/opt/python@3.10/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/opt/node/bin:$PATH"
fpath=($fpath "/Users/yasir/.zfunctions")

# Aliases
alias v='nvim'
alias ll='ls'
alias py3='python3.10'
alias pip='pip3.10'


alias y4='cd $HOME/uni/4y'
alias zshconf='nvim $HOME/.zshrc'
alias vconf='nvim $HOME/.config/nvim/init.vim'

# Starship
eval "$(starship init zsh)"
