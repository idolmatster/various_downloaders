#!/bin/bash
htmlfile="/tmp/index$(date +%s).html"
curl "$1" -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36 OPR/76.0.4017.177' -o "${htmlfile}"
url=$(cat "${htmlfile}" | grep "contentUrl" | cut -d '"' -f 4)
filename1=$(cat "${htmlfile}" | pup 'title text{}')
tmp=$(echo "${url%\?*}")
filename2=$(echo "${tmp##*/}")

curl "${url}" -o "$filename1$filename2"
rm "$htmlfile"
