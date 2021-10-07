#!/bin/bash

cyerrordownloadpage(){
    echo "there was an error downloading the page try again later."
    echo "if the issue presists please report this as an issue on github"
    exit 1
}

#=====================================================

link="$1"

if [[ "$link" == "" ]] ; then 
    echo "please supply a link as argument like $0 someurl"
    exit
fi


echo "downloading page"
webpage=$(wget "$link" -q -O - || cyerrordownloadpage)
# webpage=$(lynx -source "$link" || cyerrordownloadpage )

if [[ "$webpage" == "" ]] ; then
    echo "there was an error downloading the page try again later."
    echo "if the issue presists please report this as an issue on github"
    exit 1
fi

#extract important variables

title=$(echo "$webpage" | pup 'h1#title' attr{title} | sed 's/\// - /g' | sed 's/:/ - /g' )
# echo $title 
id=$(echo "${link#*cyberdrop.me}" | cut -d '/' -f 3)
# echo $id 

echo "creating folder \"$title ($id)\" and preping for download"
echo "if you wanna pause download crtl+c and rerun at a later point"

mkdir "$title ($id)"
cd "$title ($id)"
    
filecountexpected=$(echo "$webpage" | pup 'p#totalFilesAmount' text{})

album_linksr=$(echo "$webpage" | pup 'a.image' attr{href} )

SAVEIFS="$IFS"   # Save current IFS
IFS=$'\n'      # Change IFS to new line
album_linksa=($album_linksr)
IFS="$SAVEIFS"

#====================================================

echo "starting download"
for imgurl in "${album_linksa[@]}"
do
    wget -c -q --show-progress "$imgurl" || echo "error downloading $imgurl"
    # echo "$imgurl"
done

#====================================================
filecountrecieved=$(ls | wc -l)

echo "expected file count: $filecountexpected"
echo "recieved file count: $filecountrecieved"
if [[ $filecountrecieved -lt $filecountexpected ]] ; then
    
    echo "re-downloading for verification"
    for imgurl in "${album_linksa[@]}"
    do
        wget -c -q --show-progress "$imgurl" || echo "error downloading $imgurl"
    done
    
    filecountrecieved=$(ls | wc -l)


    if [[ $filecountrecieved -lt $filecountexpected ]]; then
        echo "expected file count: $filecountexpected"
        echo "recieved file count: $filecountrecieved"
        echo "there might be a temporary outage or a bug in the script"
        echo "please try again later if the error keep happening please report it"
        echo "here is your link again "
        echo "$link"
        exit 1
    fi
    echo "successfully downloaded the missing content"

fi 
echo "if there are any broken files the download might have broke while in progress"
echo "in that case just run the script again"
exit 0
