function updateSystem () {
    echo "[UPDATE SYSTEM]"
    sudo apt update >> /dev/null 2>&1 && sudo apt upgrade -y > /dev/null 2>&1
}
function configHome () {
    echo "[CONFIGURATION $HOME]"
    cp -RT home/ $HOME
}
function configVIM () {
    echo "[CONFIGURATION VIM]"
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
}
function basicPrograms () {
    sudo apt install -y \
        git     \
        gcc     \
        curl    \
        nmap    \
        ipcalc  \
        zsh     \
        gcc     \
        gnupg   \
        software-properties-common
        
}
# Install Golang
# Virtualization -> Vagrant and virtualbox
# Install Docker
# Kubectl
# BasicPrograms -> FlameShot, Peek, insync
# Configuration ZSH with theme power10
updateSystem
configHome
configVIM
basicPrograms
