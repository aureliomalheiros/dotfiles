function updateSystem () {
    echo "[CAT CODE]"
    sudo apt update
}
function configHome () {
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
        ca-certificates\
        lsb-release \
        apt-transport-https \
        flameshot \
        peek \
        wget https://go.dev/dl/go1.19.4.linux-amd64.tar.gz && rm -rf /usr/local/go && tar -C /usr/local -xzf go1.19.4.linux-amd64.tar.gz \
        export PATH=$PATH:/usr/local/go/bin
}
function configVIM () {
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
}
function k8s (){
    sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt update
    sudo apt install -y kubectl
    wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
}
function docker (){
    sudo apt-get remove docker docker-engine docker.io containerd runc -y
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
    sudo chmod 666 /var/run/docker.sock
}
function MyZSHWithThemePowerlevel10 () {
    sudo chsh -s /bin/zsh $USER
    wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
    sh install.sh
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k 
}
updateSystem
configHome
basicPrograms
configVIM
k8s
docker
MyZSHWithThemePowerlevel10
