#!/bin/bash

#this script might run with dash but whatever

#get a unique temp file
wallpaperListDir="/tmp/wallpaper-$(date).list"

#store website so we don't request more than we need to
website=$(curl $1)

#if the thread has a name use that as a folder name otherwise use website title just because creating folders by hand is boring
threadname=$(echo "${website}" | pup 'span.subject text{}' | uniq)
[ -z "$threadname" ] && threadname=$(echo "${website}" | pup 'title text{}' | cut -d "-" -f 2 | sed -e 's/^[[:space:]]*//')
mkdir "${threadname}"
cd "${threadname}"

# actually getting the list of files
#do not get the temp folder here because when multiple iterations of the script run this can cause issues with the time stamp being accidentally the same
echo $website | pup 'div.fileText' | pup 'a attr{href}' | | sed -e '/\/image\//! s|//|https://|g' > "${wallpaperListDir}"
#iterating through the list of images and downloading them all
tempwallapaperlist="${wallpaperListDir}"
   while IFS= read -r link
       do
           wget -c "${link}"
done <"$tempwallapaperlist"
#cleaning my mess up so it's less stuff in temp
rm "${wallpaperListDir}"
cd ..
