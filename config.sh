function updateSystem () {
    echo "[UPDATE SYSTEM]"
    sudo apt update >> /dev/null 2>&1 && sudo apt upgrade -y > /dev/null 2>&1
}
function configHome () {
    echo "[CONFIGURATION $HOME]"
    cp -RT home/ $HOME
}
function basicPrograms () {
    sudo apt install -y \
        git     \
        gcc     \
        curl    \
        nmap    \
        ipcalc  \
        zsh     \
        gnupg   \
        software-properties-common \
        ca-certificates curl \
        apt-transport-https
        
}
function configVIM () {
    echo "[CONFIGURATION VIM]"
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
}
function k8s (){
    sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt update > 2>&1
    sudo apt install -y kubectl
}

# Install Golang
# Virtualization -> Vagrant and virtualbox
# Install Docker
# Kubectl
# BasicPrograms -> FlameShot, Peek, insync
# Configuration ZSH with theme power10
updateSystem
configHome
basicPrograms
configVIM
