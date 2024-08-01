#! /bin/bash
####### Define Variables ######
echo "What is the domain name?"
read DOMAINNAME

echo "Enter path for Docker data.  ie. /mnt/docker"
read DOCKERPATH
sudo mkdir $DOCKERPATH

echo "Enter path for temp processing.  ie. /mnt/processing"
read PROCESSPATH
sudo mkdir $PROCESSPATH

echo "Enter path for Plex Media"
read MEDIAPATH 
sudo mkdir $MEDIAPATH


echo "Enter Local Network in CIDR Notation"
read LOCALNET

echo "DUCKDNS Token"
read DUCKDNSTOKEN




export DOMAINNAME=$DOMAINNAME
export DOCKERPATH=$DOCKERPATH
export PROCESSPATH=$PROCESSPATH
export MEDIAPATH=$MEDIAPATH
export PLEXCLAIM=$PLEXCLAIM
export LOCALNET=$LOCALNET
export DUCKDNSTOKEN=$DUCKDNSTOKEN


sudo rm ./frontend/.env
sudo rm ./backend/.env
sudo rm ./infrastructure/.env
cat > ./frontend/.env << EOF1
DOMAINNAME=$DOMAINNAME
DOCKERPATH=$DOCKERPATH
PROCESSPATH=$PROCESSPATH
MEDIAPATH=$MEDIAPATH
PLEXCLAIM=$PLEXCLAIM
LOCALNET=$LOCALNET
DUCKDNSTOKEN=$DUCKDNSTOKEN
EOF1

cat > ./backend/.env << EOF1
DOMAINNAME=$DOMAINNAME
DOCKERPATH=$DOCKERPATH
PROCESSPATH=$PROCESSPATH
MEDIAPATH=$MEDIAPATH
PLEXCLAIM=$PLEXCLAIM
LOCALNET=$LOCALNET
DUCKDNSTOKEN=$DUCKDNSTOKEN
EOF1

cat > ./infrastructure/.env << EOF1
DOMAINNAME=$DOMAINNAME
DOCKERPATH=$DOCKERPATH
PROCESSPATH=$PROCESSPATH
MEDIAPATH=$MEDIAPATH
PLEXCLAIM=$PLEXCLAIM
LOCALNET=$LOCALNET
DUCKDNSTOKEN=$DUCKDNSTOKEN
EOF1

###############################

##########   Docker ###########
sh ./docker.sh
###############################

########.Create Docker Networks .#######
sudo docker network create -d bridge --subnet=172.19.0.0/24 internal 
sudo docker network create -d bridge --subnet=172.20.0.0/24 external
###############################



#########.Install Components.####
sudo docker compose -f ./infrastructure/docker-compose.yaml up -d
sudo docker compose -f ./backend/docker-compose.yaml up -d
sudo docker compose -f ./frontend/docker-compose.yaml up -d
sudo rm ./frontend/.env
sudo rm ./backend/.env
sudo rm ./infrastructure/.env
