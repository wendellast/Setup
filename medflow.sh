#!/bin/bash
echo "Atualizando Sistema."
sudo apt update && sudo apt upgrade -y

echo "Instalando GOLANG."
go_url="https://go.dev/dl/go1.23.4.linux-amd64.tar.gz"
go_tar="go1.23.4.linux-amd64.tar.gz"

if ! wget "$go_url" -O "$go_tar"; then
    echo "Erro ao baixar o Go. Verifique a URL ou a conexão com a internet."
    exit 1
fi

sudo rm -rf /usr/local/go

if ! sudo tar -C /usr/local -xzf "$go_tar"; then
    echo "Erro ao extrair o arquivo $go_tar."
    exit 1
fi

echo "Adicionando Go ao PATH."

echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bashrc
export PATH=$PATH:/usr/local/go/bin

go_version=$(go version)
if [ $? -eq 0 ]; then
    echo "Instalação concluída com sucesso. Versão instalada: $go_version"
else
    echo "Erro ao verificar a instalação do Go."
    exit 1
fi
echo "Removendo arquivo $go_tar"
rm -f "$go_tar"

source ~/.bashrc

echo "Instalndo docker"

# Add Docker's official GPG key:
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo systemctl start docker
sudo systemctl enable docker


echo "Deixando docker como user padrao"
sudo usermod -aG docker $USER


echo "Instalando Docker compose"
sudo apt-get install docker-compose-plugin

