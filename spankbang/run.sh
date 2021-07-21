#!/bin/bash
htmlfile="/tmp/index$(date +%s).html"
# curl "$1" -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36 OPR/76.0.4017.177' -o "${htmlfile}"
lynx -source -accept_all_cookies "$1" > "${htmlfile}"
url=$(cat "${htmlfile}" | grep "contentUrl" | cut -d '"' -f 4)
prefix="Watch "
suffix=" Porn - SpankBang"
filename1=$(cat "${htmlfile}" | pup 'title text{}')
filename1=$(echo "$filename1" | sed -e "s/^$prefix//" -e "s/$suffix$//")
tmp=$(echo "${url%\?*}")
filename2=$(echo "${tmp##*/}")

echo $url
# echo $filename1 | cut -d '-' -f 2 | sed -e 's/^[[:space:]]*//'
curl "${url}" -o "$filename1$filename2"
rm "$htmlfile"
