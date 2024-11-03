#!/bin/bash


tmp_file="/tmp/install.tmp"


function main () {
    echo "Select your machine type: 1 - Personal, 2 - Corporate"
    read machineType

    case $machineType in 
        1)
            echo "Install all applications"
            setupPersonal
            ;;
        2) 
            echo "Install only corporate applications"
            setupCorporate
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
}

function setupPersonal () {

    echo "Add user to sudo group" 🛠
    su
    echo "Enter your username"
    read USER
    sudo usermod -aG sudo $USER

    if [ -f /etc/os-release ]; then
        . /etc/os-release

        if [[ "$ID" == "debian" ]]; then
            sudo apt install -y snapd > /dev/null > $tmp_file
        else
            echo "Your system is not Debian based. Snapd will not be installed."
        fi
    else
        echo "Not supported OS"
    fi

    updateSystem
    basicPrograms
    k8s
    terraform
    awscli
    minikube
    MyZSHWithThemePowerlevel10
    KeePass
    vscode
    configHome
    configVIM

    echo "Exit your user session and login again"
    logout
}

function setupCorporate () {
    updateSystem
    basicPrograms
    k8s
    terraform
    awscli
    MyZSHWithThemePowerlevel10
    vscode
    configHome
    configVIM
}

main

function fastUpdate () {
    echo "Fast update" 🔄
    sudo apt update > /dev/null > $tmp_file
}

function updateSystem () {
    echo "[Update and Upgrade System]" 🔄
    sudo apt update > /dev/null > $tmp_file
    sudo apt upgrade -y > /dev/null > $tmp_file
    echo "Update finished" 🆗
}

function basicPrograms () {
    echo "Install basic Programs" :shipit:
    sudo apt install -y \
        git     \
        gcc     \
        curl    \
        ipcalc  \
        zsh     \
        gnupg   \
        software-properties-common \
        ca-certificates\
        lsb-release \
        apt-transport-https \
        flameshot \
        golang-go \
        peek \
        vim \
        tilix \
        tmux \
        mariadb-client > /dev/null > $tmp_file

        echo "Install Docker" 🐳
        sudo install -m 0755 -d /etc/apt/keyrings > /dev/null > $tmp_file
        sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc > /dev/null > $tmp_file
        sudo chmod a+r /etc/apt/keyrings/docker.asc
        echo \
            "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
            $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
            sudo tee /etc/apt/sources.list.d/docker.list > /dev/null 
            sudo apt-get update > /dev/null > $tmp_file
        sudo apt-get install -y \
            docker-ce docker-ce-cli \
            containerd.io \
            docker-buildx-plugin \
            docker-compose-plugin > /dev/null > $tmp_file

        echo "Install Google Chrome" 🌐
        wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb > /dev/null > $tmp_file
        sudo dpkg -i google-chrome-stable_current_amd64.deb > /dev/null > $tmp_file

}

function k8s (){
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
    if [[ `echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check` == "kubectl: FAILED" ]]
    then
        exit 0
    fi
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
    curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
    sudo apt-get install apt-transport-https --yes
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
    fastUpdate
    sudo apt-get install helm -y ? /dev/null > $tmp_file

    sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
    sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
    sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
}

function terraform () {
    wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list
    fastUpdate
    sudo apt-get install terraform -y > /dev/null > $tmp_file
}

function cloudProvider () {
    # AWS Cloud Provider
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install -y > /dev/null > $tmp_file
    # GCP Cloud Provider
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    fastUpdate 
    sudo apt-get install google-cloud-cli > /dev/null > $tmp_file

}

function minikube () {
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    sudo apt install -y virtualbox > /dev/null > $tmp_file
}

function MyZSHWithThemePowerlevel10 () {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    sudo chsh -s /bin/zsh $USER
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k 
    cp home/.p10k.zsh ~/.p10k.zsh
    cp home/.zshrc ~/.zshrc
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
}
function KeePass () {
    sudo add-apt-repository ppa:phoerious/keepassxc
    fastUpdate
    sudo apt install keepassxc -y > /dev/null > $tmp_file
}
function vscode () {
    sudo apt install software-properties-common apt-transport-https wget
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    fastUpdate
    sudo apt install code -y > /dev/null > $tmp_file
}
function configHome () {
    cp -RT home/ $HOME
}
function configVIM () {
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
}



