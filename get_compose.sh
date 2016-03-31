sudo mkdir -p /opt/bin
curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > docker-compose
sudo mv docker-compose /opt/bin/docker-compose
sudo chmod +x /opt/bin/docker-compose
