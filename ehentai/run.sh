#/bin/bash

pagecount="$2"
baseurl="$1"
pageadd="?p="
echo "$baseurl"

tempfile="/tmp/urls$(date +%s).url"
useragent="user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36 OPR/76.0.4017.177"

get_gallery(){
    curl "$galleryurl" \
    -H 'authority: e-hentai.org' \
    -H "$useragent"\
    --compressed | pup 'div#gdt div.gdtm a attr{href}' > "$tempfile"
}

download_gallery(){
    tempfile="$tempfile"
    while IFS= read -r link
        do
            sleep 0.5
            link=$(curl "$link" -H 'authority: e-hentai.org' -H "$useragent" --compressed | pup 'img#img attr{src}')
            name=$(echo "$link" | rev | cut -d'/' -f 1 | rev)
            curl "$link" -H "$useragent" -o "$name" -C -
    done <"$tempfile"
}

galleryname=$(curl "$baseurl" -H 'authority: e-hentai.org' -H "$useragent" --compressed | pup 'h1#gn text{}')
mkdir "$galleryname"
cd "$galleryname"

echo $pagecount
if [  -z "$2" ]
    then
        galleryurl="$baseurl"
        get_gallery
        download_gallery

        rm "$tempfile"
        exit 0
fi

for I in `seq 0 $pagecount`
do
    galleryurl="$baseurl$pageadd$I"
    echo "$galleryurl"
    get_gallery
    download_gallery
done

rm "$tempfile"
