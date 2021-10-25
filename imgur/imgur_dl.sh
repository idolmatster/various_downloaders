#!/bin/bash

link="$1"

page=$(curl "$link" -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36 Edg/95.0.1020.30' --compressed)
title=$(echo "$page" | pup 'title text{}' | sed 's/\// - /g' | sed 's/|/ - /g')

# get shortcode
shortcode=$(echo ${link##*imgur.com/})
shortcode=$(echo ${shortcode##*a/})
shortcode=$(echo ${shortcode##*gallery/})
shortcode=$(echo ${shortcode##*t/*/})
shortcode=$(echo ${shortcode%%/*})
#echo $shortcode

folder_name="${title}-imgur(${shortcode})"
mkdir "$folder_name"
cd "$folder_name"

script_link=$(echo "$page" | pup 'script attr{src}' | grep "js/main.")
script=$(curl "$script_link" | head -n 1 > script.js)

# get token from script
client_id=$(../tokenscript)
#echo $client_id
rm script.js

# would recomend changing out client in order to not stick out like a sore thumb if you don't run linux and use edge
api_res=$( curl "https://api.imgur.com/post/v1/albums/${shortcode}?client_id=${client_id}&include=media%2Cadconfig%2Caccount" \
  -H 'authority: api.imgur.com' \
  -H 'sec-ch-ua: "Microsoft Edge";v="95", "Chromium";v="95", ";Not A Brand";v="99"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36 Edg/95.0.1020.30' \
  -H 'sec-ch-ua-platform: "Linux"' \
  -H 'accept: */*' \
  -H 'origin: https://imgur.com' \
  -H 'sec-fetch-site: same-site' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-dest: empty' \
  -H 'referer: https://imgur.com/' \
  -H 'accept-language: en-US,en;q=0.9' \
  --compressed )

#echo "$api_res"

for k in  $(echo "$api_res" | jq -r '.media | keys | .[]'); do
    wget -c $(echo "$api_res" | jq ".media[$k].url" -r)
done

exit 0
