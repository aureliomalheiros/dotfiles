function updateSystem () {
    echo "[CAT CODE]"
    sudo apt update
}
function basicPrograms () {
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
        peek \
        fzf \
        vim \
        podman \
        tilix \
        mariadb-client \
        virtualbox
        # Google Chrome
        wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
        sudo apt --fix-broken install -y
        # Golang
        wget https://go.dev/dl/go1.21.1.linux-amd64.tar.gz 
        sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf https://go.dev/dl/go1.21.1.linux-amd64.tar.gz 
        rm go1.21.1.linux-amd64.tar.gz 
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
    sudo apt-get update
    sudo apt-get install helm -y

    sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
    sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
    sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
}
function terraform () {
    sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
    wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update
    sudo apt-get install terraform -y
}

function awscli () {
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install -y
}
function minikube () {
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
}
function MyZSHWithThemePowerlevel10 () {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    sudo chsh -s /bin/zsh $USER
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k 
    cp home/.p10k.zsh ~/.p10k.zsh
    cp home/.zshrc ~/.zshrc
}
function KeePass () {
    sudo add-apt-repository ppa:phoerious/keepassxc
    sudo apt update
    sudo apt install keepassxc -y
}
function vscode () {
    sudo apt install software-properties-common apt-transport-https wget
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    sudo apt update
    sudo apt install code -y
}
function configHome () {
    cp -RT home/ $HOME
}
function configVIM () {
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
}
function displayLinkDocStation () {
    chmod +x packages/displaylink-driver-5.8.0-63.33.run
    ./packages/displaylink-driver-5.8.0-63.33.run
}
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
displayLinkDocStation
