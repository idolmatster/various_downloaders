#!/bin/bash

link="$1"

cyerrordownloadpage(){
    echo "there was an error downloading the page try again later."
    echo "if the issue presists please report this as an issue on github"
    exit 1
}

error_dl_img(){
    wget -c -q --show-progress "$img_url" && return
    failed_images+=("$failed_imagesimg_url")
    mkdir preview_for_failed_downloads
    cd preview_for_failed_downloads
    prev_img_url=$(echo "$api_res" | jq -r ".files[$i].file" )
    wget -c -q --show-progress "$prev_img_url"
    cd ..
    return
}

#=====================================================

api_baseurl="https://cyberdrop.me/api/album/get/"

if [[ "$link" == "" ]] ; then 
    echo "please supply a link as argument like $0 someurl"
    exit
fi

echo "downloading page"

id=$(echo "${link##*/a/}" | cut -d '?' -f 1 | cut -d '/' -f 1 )
api_res=$(wget "$api_baseurl$id" -q -O - || cyerrordownloadpage)

res_state=$(echo "$api_res" | jq -r '.success') 
if [[ "$res_state" == "" ]] ; then
    res_state=$(echo "$api_res" | jq -r '.description')
    echo "Error Code: $res_state"
    if [[ "$res_state" == 'An unexpected error occcured. Try again?' ]]; then
        echo "ATTENTION: this might solve it self in a few minutes"
    fi
    exit 1
fi

title=$(echo "$api_res" | jq -r '.title' | sed "s/[<>:\"/\|?*]/-/g; s/ $//; s/ /_/g;")

filecountexpected=$(echo "$api_res" | jq -r '.count' )
if [[ "$filecountexpected" == "0" ]]; then
    echo "this album is empty"
    echo "you link was $link please go onto the site and check if the album is empty" 
    exit 0
fi

echo "creating folder \"$title ($id)\" and preping for download"
echo "if you wanna pause download crtl+c and rerun at a later point"

mkdir "$title ($id)"
cd "$title ($id)"
    
#====================================================
echo "starting download"
#declaring empty array
failed_images=()
count="$((filecountexpected-1))"
for i in `seq 0 $count`;
do
    echo "downloading $((i+1)) / $filecountexpected"
    img_url=$(echo "$api_res" | jq -r ".files[$i].file" )
    echo "$img_url"
    wget -c -q --show-progress "$img_url" || error_dl_img
done 

#====================================================
filecountrecieved=$(find -type f -ls | wc -l)

echo "expected file count: $filecountexpected"
echo "recieved file count: $filecountrecieved"
if [[ $filecountrecieved -lt $filecountexpected ]] ; then
    
    echo "re-downloading for verification"
    for img_url in "${failed_images[@]}";
    do
        wget -c -q --show-progress "$img_url" || echo "error downloading $img_url"
    done
    
    filecountrecieved=$(find -type f -ls | wc -l)

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
