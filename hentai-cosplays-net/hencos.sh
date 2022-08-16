#!/bin/bash

link=$1
useragent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36"

echo "[hentai-cosplays] downloading page data"

    #preserver ifs
    SAVEIFS=$IFS   # Save current IFS
    IFS=$'\n'      # Change IFS to new line

    hc_dl(){
        # for link in page_link_gallery download image
        for dllink in "${page_gallery[@]}"
        do
            sleep 1
            dllink=$(echo "$dllink" | sed 's/p=700\///')
            authority=$(echo "${link%/upload/*}" | cut -d '/' -f 3)
            curl "${dllink}" \
                -H "authority: ${authority}" \
                -H 'pragma: no-cache' \
                -H 'cache-control: no-cache' \
                -H 'sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="99", "Opera";v="85"' \
                -H 'sec-ch-ua-mobile: ?0' \
                -H 'sec-ch-ua-platform: "Windows"' \
                -H 'upgrade-insecure-requests: 1' \
                -H "user-agent: ${useragent}" \
                -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
                -H 'sec-fetch-site: none' \
                -H 'sec-fetch-mode: navigate' \
                -H 'sec-fetch-user: ?1' \
                -H 'sec-fetch-dest: document' \
                -H 'accept-language: de-DE,de;q=0.9,en-US;q=0.8,en;q=0.7' \
                --compressed -C - -O
        done
    }

    #script env
    page=$(wget -qO- $link --user-agent="${useragent}")
    title=$(echo $page | pup 'span#title h2 text{}' | sed "s/[:/|?]/-/g; s/%20/ /g; s/–/-/g; s/ $//; s/&amp;/\&/g") 

    mkdir "$title"
    cd "$title"

    echo "[hentai-cosplays] downloading $title"

    page_galleryr=$(echo "$page" | pup 'div#display_image_detail div.icon-overlay a img attr{src}')
    page_gallery=($page_galleryr)
    hc_dl

    galleryname=$(echo ${link##*/image/} | cut -d '/' -f 1)
    pagecounter=$(echo "$page" | pup 'div#paginator span a attr{href}' | grep "image/$galleryname/")
    # echo $pagecounter

    if [[ $pagecounter == "" ]]; then
        # return to default ifs (let's hope this does not break other stuff but otherwise you know what to do!)
        IFS=$SAVEIFS
    else

        # got figure out last page number since all page number will be printed choose last in array
        page_count=($pagecounter)
        pagecount=$(echo ${page_count[-1]})
        pagecount=$(echo ${pagecount##*/page/} | cut -d '/' -f 1)
        echo pagecount: $pagecount

        # iterate through all pages
        for I in `seq 2 $pagecount`
        do
            echo "[hentai-cosplays] downloading page $I data "
            galleryurl="$link/page/$I"
            galleryurl="https://hentai-cosplays.com/image/$galleryname/page/$I"
            echo "$galleryurl"
            page=$(wget -qO- "$galleryurl" --user-agent="${useragent}")
            page_galleryr=$(echo $page | pup 'div#display_image_detail div.icon-overlay a img attr{src}')
            page_gallery=($page_galleryr)
            hc_dl
        done

    fi
    # check after the fact
    max_file_count=$(ls -t | head -n 1 | cut -d '.' -f 1)
    curren_file_count=$(ls | wc -l )

    # echo "=================================================="
    # echo "===                $max_file_count == $curren_file_count                  ==="
    # echo "=================================================="
    echo "[hentai-cosplays] highest file number: $max_file_count / file count: $curren_file_count "

    if [[ "$curren_file_count" -lt "$max_file_count" ]] ; then
        echo "[hentai-cosplays] less files then expected, overshooting"
        sleep 1

        dllink="${dllink%/*}/"
            
        ext=".jpg"
        altext=".png"
        text=".gif"

        for I in `seq 1 $max_file_count`
        do
            wget -c "${dllink}${I}${ext}" \
                --user-agent="$useragent" \
                --header="authority: $authority" || wget -c "${dllink}${I}${altext}" \
                --user-agent="$useragent" \
                --header="authority: $authority" || wget -c "${dllink}${I}${text}" \
                --user-agent="$useragent" \
                --header="authority: $authority"
        done

        # try to overshoot
        failed="0"
        i="$max_file_count"
        while [[ "$failed" -lt "2" ]]
        do
            i=$((i+1))
            wget -c "${dllink}${i}${ext}" \
                --user-agent="$useragent" \
                --header="authority: $authority" || wget -c "${dllink}${i}${altext}" \
                --user-agent="$useragent" \
                --header="authority: $authority" || wget -c "${dllink}${i}${text}" \
                --user-agent="$useragent" \
                --header="authority: $authority" || failed=$((failed+1))
        done

    fi
    exit 0
