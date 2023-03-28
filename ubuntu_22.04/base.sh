#!/usr/bin/env bash
export NEEDRESTART_MODE=a

# Text Color Variables
GREEN='\033[32m'  # Green
YELLOW='\033[33m' # YELLOW
BLUE='\033[34m'   # BLUE
CYAN='\033[36m'   # CYAN
WHITE='\033[37m'  # WHITE
BOLD='\033[1m'    # BOLD
CLEAR='\033[0m'   # Clear color and formatting

# Startup
echo -e "${BLUE}${BOLD}=> ${WHITE}Install Basic Tool${CLEAR}"

# Activate sudo permission
echo -e "\n${BLUE}${BOLD}=> ${WHITE}Check for sudo permission${CLEAR}"
sudo -v

install_basic_tools() {
    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Update${CLEAR}"
    sudo apt-get update

    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Nano${CLEAR}"
    sudo apt-get install nano

    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Git & GPG${CLEAR}"
    sudo -E apt-get -y install git gpg

    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Update${CLEAR}"
    sudo apt-get update

    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Curl${CLEAR}"
    sudo apt-get -y install curl

    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Update${CLEAR}"
    sudo apt-get update

    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Htop${CLEAR}"
    sudo -E apt-get -y install htop

    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Net-tools${CLEAR}"
    sudo apt-get install net-tools
}

setup_basic_config() {
    echo -e "\n${YELLOW}${BOLD}STEP ${BLUE}=> ${WHITE}Git user config${CLEAR}"
    git config --global user.email "k0970133227@gmail.com"
    git config --global user.name "ej0331"

    echo -e "\n${YELLOW}${BOLD}STEP ${BLUE}=> ${WHITE}Set default branch${CLEAR}"
    git config --global init.defaultBranch main

    echo -e "\n${YELLOW}${BOLD}STEP ${BLUE}=> ${WHITE}Setup ssh${CLEAR}"
    if [ -f "id_ed25519" ]; then
        echo -e "${CYAN}${BOLD}CHECK ${BLUE}=> ${GREEN}SSH private key exists!${CLEAR}"

        echo -e "\n${CYAN}${BOLD}STEP ${BLUE}=> ${WHITE}Make .ssh directory${CLEAR}"
        mkdir -p ~/.ssh

        echo -e "\n${CYAN}${BOLD}STEP ${BLUE}=> ${WHITE}Import SSH private key${CLEAR}"
        cp id_ed25519 ~/.ssh
        chmod 600 ~/.ssh/id_ed25519

        if [ -f "id_ed25519" ]; then
            echo -e "${CYAN}${BOLD}CHECK ${BLUE}=> ${GREEN}Paired SSH public key exists!${CLEAR}"

            echo -e "\n${CYAN}${BOLD}STEP ${BLUE}=> ${WHITE}Import SSH public key${CLEAR}"
            cp id_ed25519.pub ~/.ssh
            chmod 644 ~/.ssh/id_ed25519.pub
        fi
    else
        echo -e "${CYAN}${BOLD}CHECK ${BLUE}=> ${YELLOW}SSH private key not exist!${CLEAR}"

        echo -e "\n${CYAN}${BOLD}STEP ${BLUE}=> ${WHITE}Make .ssh directory${CLEAR}"
        mkdir -p ~/.ssh

        echo -e "\n${CYAN}${BOLD}STEP ${BLUE}=> ${WHITE}Generate a new ed25519 key pair${CLEAR}"
        ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""
    fi
}

install_node() {
    echo -e "\n${YELLOW}${BOLD}STEP ${BLUE}=> ${WHITE}Install nvm${CLEAR}"
    export NVM_DIR="$HOME/.nvm" && (
        git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
        cd "$NVM_DIR"
        git checkout $(git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1))
    ) && \. "$NVM_DIR/nvm.sh"

    echo -e "\n${YELLOW}${BOLD}STEP ${BLUE}=> ${WHITE}Install latest lts version${CLEAR}"
    nvm install --lts

    echo -e "\n${YELLOW}${BOLD}STEP ${BLUE}=> ${WHITE}Enable corepack for yarn and pnpm${CLEAR}"
    corepack enable
}

install_docker() {
    sudo apt-get update

    echo -e "\n${YELLOW}${BOLD}STEP ${BLUE}=> ${WHITE}Install Docker Engine${CLEAR}"
    sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg

    sudo mkdir -m 0755 -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update

    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
}

install_laravel() {
    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Install Tasksel${CLEAR}"
    sudo apt-get install tasksel -y

    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Install Apache${CLEAR}"
    sudo apt-get install apache2 -y

    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Install MySQL${CLEAR}"
    sudo apt-get install mysql-server -y

    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Install php packeges${CLEAR}"
    sudo DEBIAN_FRONTEND=noninteractive apt install -y php8.1 libapache2-mod-php php-mbstring php-cli php-bcmath php-json php-xml php-zip php-pdo php-common php-tokenizer php-mysql
    
    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Update${CLEAR}"
    sudo apt-get update

    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Install composer${CLEAR}"
    curl -sS https://getcomposer.org/installer | php

    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Move composer file${CLEAR}"
    sudo mv composer.phar /usr/local/bin/composer

    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Assign execute permission${CLEAR}"
    sudo chmod +x /usr/local/bin/composer
    
    # 需要啟專案再打開
    # echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Navigate to the webroot directory${CLEAR}"
    # cd /var/www/html

    # echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Install laravel${CLEAR}"
    # sudo composer create-project laravel/laravel laravelapp

    # sudo chown -R www-data:www-data /var/www/html/laravelapp
    # sudo chmod -R 775 /var/www/html/laravelapp/storage
}

install_vscode() {
    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Visual Studio Code${CLEAR}"
    echo -e "${CYAN}${BOLD}STEP ${BLUE}=> ${WHITE}Download deb file${CLEAR}"
    curl -SL https://az764295.vo.msecnd.net/stable/ee2b180d582a7f601fa6ecfdad8d9fd269ab1884/code_1.76.2-1678817477_arm64.deb --output code.deb
    echo -e "${CYAN}${BOLD}STEP ${BLUE}=> ${WHITE}Install${CLEAR}"
    cp code.deb /tmp
    sudo -E apt -y install /tmp/code.deb
}

install_mosquitto() {
    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Mosquitto${CLEAR}"
    sudo apt-get update
    sudo apt-get -y install mosquitto
    sudo apt-get -y install mosquitto-clients
}

clean_up() {
    echo -e "\n${YELLOW}${BOLD}STEP ${BLUE}=> ${WHITE}Clean up apt packages${CLEAR}"
    sudo -E apt-get -y --purge autoremove
    sudo -E apt-get clean
    sudo -E apt-get autoclean
}

install_all() {
    echo -e "\n${GREEN}${BOLD}SETUP ${BLUE}=> ${CYAN}Install basic tools${CLEAR}"
    install_basic_tools

    echo -e "\n${GREEN}${BOLD}SETUP ${BLUE}=> ${CYAN}Setup basic config${CLEAR}"
    setup_basic_config

    echo -e "\n${GREEN}${BOLD}SETUP ${BLUE}=> ${CYAN}Install Mosquitto${CLEAR}"
    install_mosquitto

    echo -e "\n${GREEN}${BOLD}SETUP ${BLUE}=> ${CYAN}Install Node.js${CLEAR}"
    install_node

    echo -e "\n${GREEN}${BOLD}SETUP ${BLUE}=> ${CYAN}Install laravel${CLEAR}"
    install_laravel

    echo -e "\n${GREEN}${BOLD}SETUP ${BLUE}=> ${CYAN}Install vscode${CLEAR}"
    install_vscode

    echo -e "\n${GREEN}${BOLD}SETUP ${BLUE}=> ${CYAN}Install Docker${CLEAR}"
    install_docker

    echo -e "\n${GREEN}${BOLD}POST SETUP ${BLUE}=> ${CYAN}Clean-Up${CLEAR}"
    clean_up
}

check_version() {
    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Check Php version${CLEAR}"
    php -version

    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Check Mysql version${CLEAR}"
    mysql -V

    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Check Composer version${CLEAR}"
    composer --version

    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Check Docker version${CLEAR}"
    docker --version
}

install_all

echo -e "\n${BLUE}${BOLD}=> ${WHITE}Basic Tool Install Complete!${CLEAR}\n"

if [ "$1" != "--called-from-another" ]; then
    echo -e "\n${BLUE}${BOLD}=> ${WHITE}Install Complete! Restart your computer to continue!${CLEAR}"
fi

check_version
