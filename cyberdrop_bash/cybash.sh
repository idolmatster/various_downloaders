#!/bin/bash
errordownloadpage(){
    echo "there was an error downloading the page try again later."
    echo "if the issue presists please report this as an issue on github"
    exit
}

#=====================================================
#download page

echo "downloading page"
webpage=$(wget $1 -q -O - || errordownloadpage )

echo "creating folder and preping for download"
echo "if you wanna pause download crtl+c and rerun at a later point"

#extract important variables

title=$(echo $webpage | pup 'h1#title' attr{title} | sed 's/\// - /g' | sed 's/:/ - /g' )

# adjust for https or no https in link
if [[ "${1}" == *"https://"* || "${1}" == *"http://"* ]]; then
    id=$(echo $1 | cut -d '/' -f 5)
else
    id=$(echo $1 | cut -d '/' -f 3)
fi

filecountexpected=$(echo $webpage | pup 'p#totalFilesAmount' text{})

album_linksr=$(echo $webpage | pup 'a.image' attr{href} )

# creates the file list with ifs "splitting" on newline
IFS=$'\n'      # Change IFS to new line
SAVEIFS=$IFS   # Save current IFS
album_linksa=($album_linksr)
IFS=$SAVEIFS 

# echo $title 
# echo $id 

mkdir "$title ($id)"
cd "$title ($id)"

#====================================================

echo "starting download"
for link in "${album_linksa[@]}"
do
	wget -c "$link"
    excho "$link"
done

#====================================================
filecountrecieved=$(ls | wc -l)

echo "expected file count: $filecountexpected"
echo "recieved file count: $filecountrecieved"
if [[ $filecountrecieved -lt $filecountexpected ]] ; then

    echo "re-downloading for verification"
    for link in "${album_linksa[@]}"
    do
	    wget -c "$link"
    done
    
    if [[ $filecountrecieved -lt $filecountexpected ]]; then
        echo "there might be a temporary outage or a bug in the script"
        echo "please try again later if the error keep happening please report it"
        exit 1
    fi
    exit 0
fi 
echo "if there are any broken files the download might have broke while in progress"
echo "in that case just run the script again"
exit 0
