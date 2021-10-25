#!/bin/bash

sudo apt update -y
sudo apt upgrade -y

sudo apt install golang -y
sudo apt install jq -y
sudo apt install curl -y
sudo apt install wget -y


mkdir ~/imgurscript
cd ~/imgurscript
wget "https://github.com/idolmatster/various_downloaders/releases/download/download_repo/imgur_release.tar.gz"

tar -xvf imgur_release.tar.gz
rm imgur_release.tar.gz
go build tokenscript.go
chmod +x tokenscript
chmod +x imgur_dl.sh

echo "done! check the output to see if everything went well"
echo "if so your tools should sit in ~/imgurscript "
