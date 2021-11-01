#!/bin/bash

link="$1"

# TODO Replace with steahlth palatform based most likely browser
# darwin = safari ; linux = firefox
# include normal browser headers to not raise more awareness

page=$(curl "$link" \
    -H 'authority: www.instagram.com' \
    -H 'cache-control: max-age=0' \
    -H 'sec-ch-ua: "Chromium";v="94", " Not A;Brand";v="99", "Opera";v="80"' \
    -H 'sec-ch-ua-mobile: ?0' \
    -H 'sec-ch-ua-platform: "Windows"' \
    -H 'upgrade-insecure-requests: 1' \
    -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.81 Safari/537.36 OPR/80.0.4170.63' \
    -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
    -H 'sec-fetch-site: none' \
    -H 'sec-fetch-mode: navigate' \
    -H 'sec-fetch-user: ?1' \
    -H 'sec-fetch-dest: document' \
    -H 'accept-language: de-DE,de;q=0.9,en-US;q=0.8,en;q=0.7' \
    --compressed)

# getting post object from page source
media_edges=$( echo "$page" | grep "<script type=\"text/javascript\">window._sharedData = " | sed 's/<script type="text\/javascript">window._sharedData = //; s/;<\/script>//' | jq '.entry_data.PostPage[0].graphql.shortcode_media' )

# make folder with shortcode in order to not fill directories too fast
dir_name=$( echo "$media_edges" | jq -r '.shortcode' )
mkdir "$dir_name"
cd "$dir_name"

# after this point we only need content details which are in sidecar
media_edges=$(echo "$media_edges" | jq '.edge_sidecar_to_children')
# lets keep this so we can look into details like tagged people or text in the insta post later on
# comment out if you're not a data hoarder or as we now call them data scientist
echo "$media_edges" > obj.json

# iterate through post media
for i in  $(echo "$media_edges" | jq '.edges | keys | .[]'); do
    # simplify by adding edge as variable
    edge_post=$(echo "$media_edges" | jq ".edges[$i]")
    max_height_post=$(echo "$edge_post" | jq -r ".node.dimensions.height")
    is_video=$(echo "$edge_post" | jq -r ".node.is_video")
    
    # check if it's an image because they are difrently made from videos
    if [[ "$is_video" == *"false"* ]] ; then

        for j in  $(echo "$edge_post" | jq -r '.node.display_resources | keys | .[]'); do
            # we need to iterate to get the highest quality image in the resources array
            # thanks to fb/insta thininking including max res
            cur_image_height_post=$(echo "$edge_post" | jq -r ".node.display_resources[$j].config_height")
            # echo "max : $max_height_post curr: $cur_image_height_post " 
            if [[ "$max_height_post" -eq "$cur_image_height_post" ]]; then
                src=$(echo "$edge_post" | jq -r ".node.display_resources[$j].src")
                output_name="${src%\?*}"
                output_name="${output_name##*/}"
                # TODO stealthy curl
                curl "$src" -H 'sec-ch-ua: "Chromium";v="94", " Not A;Brand";v="99", "Opera";v="80"' -H 'Referer: https://www.instagram.com/' -H 'Origin: https://www.instagram.com' -H 'sec-ch-ua-mobile: ?0' -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.81 Safari/537.36 OPR/80.0.4170.63' -H 'sec-ch-ua-platform: "Windows"' --compressed -o "$output_name"
            fi
        done 
    else
        video_url=$(echo "$edge_post" | jq -r ".node.video_url")
        output_name="${video_url%\?*}"
        output_name="${output_name##*/}"
        # TODO stealthy curl
        curl "$video_url" -H 'sec-ch-ua: "Chromium";v="94", " Not A;Brand";v="99", "Opera";v="80"' -H 'Referer: https://www.instagram.com/' -H 'Origin: https://www.instagram.com' -H 'sec-ch-ua-mobile: ?0' -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.81 Safari/537.36 OPR/80.0.4170.63' -H 'sec-ch-ua-platform: "Windows"' --compressed -o "$output_name"
    fi
done

