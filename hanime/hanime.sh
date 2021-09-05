#!/bin/bash

#download webpage
#page=$(curl $1)
page=$(cat index.html)

# content at the beginnig of and end of script tag
data=$(echo ${page##*window.__NUXT__=})
data=$( echo ${data%%;</script>*})

# replaceing symbol code with symbol / 
data2=$(echo $data | sed 's|\u002F|/|g')

# for debug
#echo $data2 > tmp.json

# TODO : FIX choosing highest quality stream instead of 720p
# parse the title and url with jq from script json of the page
title=$(echo $data2 | jq '.state.data.video.hentai_video.name' -r)

videomanifest=$(echo $data2 | jq '.state.data.video.videos_manifest.servers[0]' -r)

((resolution=0))
url="empty"

for k in  $(jq -r '.streams | keys | .[]' <<< "$videomanifest"); do
    height=$( echo $videomanifest | jq ".streams[$k].height" -r)
    width=$( echo $videomanifest | jq ".streams[$k].width" -r)
    lurl=$( echo $videomanifest | jq ".streams[$k].url" -r)
    ((lresolution=$height*$width))

    if (($lresolution > $resolution)); then
        if [[ "$lurl" != "" ]]; then
            url=$(echo $lurl)
            resolution=$(echo $lresolution)
        fi
    fi
echo $lresolution - $url
done
# echo $url

# for debug
echo $url
echo $title

# downloading stream with ffmpeg
ffmpeg -i "${url}" -bsf:a aac_adtstoasc -vcodec copy -c copy -crf 50 "${title}.mp4"
