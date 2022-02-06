#!/bin/bash

echo "this script will only work on debian/ubuntu based systems"
echo "first we'll update your pc if you don't want to update your system crtl+c and edit this part out"
echo "press any button to confirm..."

read 

sudo apt update
sudo apt upgrade -y 
sudo apt install bash -y
# that program is just great to use
# look it up https://github.com/ericchiang/pup
sudo apt install jq -y 
sudo apt install wget -y
sudo apt install cut -y

echo "you can install the script to ~/./local/bin from a github release"
echo "the url is https://github.com/idolmatster/various_downloaders/releases/download/download_repo/cydl.sh"
printf "Do you want to continue? [y/n] "
read des

if [[ "$des" == "y" ]] ; then 
    curl "https://github.com/idolmatster/various_downloaders/releases/download/download_repo/cydl.sh" -o ~/.local/bin/cybash.sh
    chmod 700 ~/.local/bin/cybash.sh
fi
