if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:/usr/local/go/bin
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git)
source $ZSH/oh-my-zsh.sh

typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
if [ -f '/opt/google-cloud-sdk/path.zsh.inc' ]; then . '/opt/google-cloud-sdk/path.zsh.inc'; fi

if [ -f '/opt/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/opt/google-cloud-sdk/completion.zsh.inc'; fi
source ~/powerlevel10k/powerlevel10k.zsh-theme

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source ~/powerlevel10k/powerlevel10k.zsh-theme
