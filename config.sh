#!/bin/bash


tmp_file=$(mktemp)


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

function setupPersonal () 

    updateSystem
    basicPrograms
    k8s
    awscli
    MyZSHWithThemePowerlevel10
    vscode
    configHome
    configVIM

}

function setupCorporate () {
    updateSystem
    basicPrograms
    k8s
    awscli
    MyZSHWithThemePowerlevel10
    vscode
    configHome
    configVIM
}

function fastUpdate () {
    echo "Fast update" 🔄
    sudo apt update > "$tmp_file" 2>&1
}

function updateSystem () {
    echo "[Update and Upgrade System]" 🔄
    sudo apt update > "$tmp_file" 2>&1
    sudo apt upgrade -y > "$tmp_file" 2>&1
    echo "Update finished" 🆗
}

function basicPrograms () {
    echo "Install basic Programs" 📦
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
        fzf \
        gpg \
        mariadb-client > "$tmp_file" 2>&1

        echo "Install NotesNook" 📝
        sudo snap install notesnook > "$tmp_file" 2>&1

        echo "Install keepassxc" 🔐
        sudo snap install keepassxc > "$tmp_file" 2>&1

        echo "Install Docker" 🐳 
        sudo install -m 0755 -d /etc/apt/keyrings > "$tmp_file" 2>&1
        sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc > "$tmp_file" 2>&1
        sudo chmod a+r /etc/apt/keyrings/docker.asc
        echo \
            "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
            $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
            sudo tee /etc/apt/sources.list.d/docker.list > /dev/null 
            sudo apt-get update > "$tmp_file" 2>&1
        sudo apt-get install -y \
            docker-ce docker-ce-cli \
            containerd.io \
            docker-buildx-plugin \
            docker-compose-plugin > "$tmp_file" 2>&1

        echo "Install Google Chrome" 🌐
        wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb > "$tmp_file" 2>&1
        sudo dpkg -i google-chrome-stable_current_amd64.deb > "$tmp_file" 2>&1
        sudo apt --fix-broken install -y > "$tmp_file" 2>&1

}

function k8s (){
    echo "Configure Env k8s" 🚀

    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
    if [[ `echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check` == "kubectl: FAILED" ]]
    then
        exit 0
    fi
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl > "$tmp_file" 2>&1
    wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash > "$tmp_file" 2>&1
    curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
    sudo apt-get install apt-transport-https --yes > "$tmp_file" 2>&1
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
    fastUpdate
    sudo apt-get install helm -y ? "$tmp_file" 2>&1

    sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
    sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
    sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens

    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube > "$tmp_file" 2>&1
    sudo apt install -y virtualbox > "$tmp_file" 2>&1
}

function cloudProvider () {
    echo "Install Cloud Provider" ☁️
    # AWS Cloud Provider
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" > "$tmp_file" 2>&1
    unzip awscliv2.zip > "$tmp_file" 2>&1
    sudo ./aws/install -y > "$tmp_file" 2>&1
    # GCP Cloud Provider
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    fastUpdate 
    sudo apt-get install google-cloud-cli > "$tmp_file" 2>&1

}

function MyZSHWithThemePowerlevel10 () {
    echo "Configure my zsh with theme powerlevel10" 🚀

    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    sudo chsh -s /bin/zsh $USER
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k 
    cp home/.p10k.zsh ~/.p10k.zsh
    cp home/.zshrc ~/.zshrc
    sudo git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
}

function vscode () {
    echo "Install Visual Studio Code" 📝
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
    fastUpdate
    sudo apt install code -y > "$tmp_file" 2>&1
}
function configHome () {
    cp -RT home/ $HOME
}
function configVIM () {
    echo "Config VIM" 📝
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
}

main