function updateSystem () {
    echo "[UPDATE SYSTEM]"
    sudo apt update >> /dev/null 2>&1 && sudo apt upgrade -y > /dev/null 2>&1
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
        gcc     \
        gnupg   \
        software-properties-common
        
}
function languageGO (){

}
function k8sKubeCtl (){
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    chmod +x kubectl
    mkdir -p ~/.local/bin
    mv ./kubectl ~/.local/bin/kubectl
}
function ohMyZSH () {

}
function virtualization () {

}

function terraform () {
    wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
    gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update > /dev/null 2>&1
    sudo apt install -y terraform
}

