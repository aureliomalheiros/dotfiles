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
        peek 
        wget https://go.dev/dl/go1.19.4.linux-amd64.tar.gz 
        sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.19.4.linux-amd64.tar.gz
}
function configHome () {
    cp -RT home/ $HOME
}
function configVIM () {
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
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
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    sudo chsh -s /bin/zsh $USER
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k 
    cp home/.p10k.zsh ~/.p10k.zsh
    cp home/.zshrc ~/.zshrc
}

function gcloud (){
    curl https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-412.0.0-linux-x86_64.tar.gz > /tmp/google-cloud-sdk.tar.gz
    sudo tar -zxf /tmp/google-cloud-sdk.tar.gz --directory /opt/
    sudo /opt/google-cloud-sdk/install.sh --quiet
    sudo /opt/google-cloud-sdk/bin/gcloud --quiet components install gke-gcloud-auth-plugin kubectl alpha beta
}
updateSystem
basicPrograms
configHome
configVIM
k8s
docker
MyZSHWithThemePowerlevel10
gcloud
