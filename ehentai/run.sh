#/bin/bash
link="$1"

pagecount="$2"
baseurl="$link"
pageadd="?p="
echo "$baseurl"

useragent="user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36 OPR/76.0.4017.177"

#preserver ifs
SAVEIFS=$IFS   # Save current IFS
IFS=$'\n'      # Change IFS to new line

get_gallery(){
    album_linksr=$(curl "$galleryurl" -H 'authority: e-hentai.org' -H "$useragent" --compressed | pup 'div#gdt div.gdtm a attr{href}')
    album_linksa=($album_linksr)
    echo "$album_linksa[@]"
    echo "starting download content of page $I"
    for link in "${album_linksa[@]}"
    do
        sleep 0.5
        link=$(curl "$link" -H 'authority: e-hentai.org' -H "$useragent" --compressed | pup 'img#img attr{src}')
        name=$(echo "$link" | rev | cut -d'/' -f 1 | rev)
        echo "$name  - $link"
        curl "$link" -H "$useragent" -o "$name" -C -
    done
}

galleryname=$(curl "$baseurl" -H 'authority: e-hentai.org' -H "$useragent" --compressed | pup 'h1#gn text{}')
mkdir "$galleryname"
cd "$galleryname"

gallerycounter=$(curl "$link" -H 'authority: e-hentai.org' -H "$useragent" --compressed | pup 'table.ptt a text{}')
pagecounter=($gallerycounter)
pagecount=$(echo ${pagecounter[-2]})

echo $pagecount
if [[ $pagecount == "" ]] ; then
    pagecount=0
fi

for I in `seq 0 $pagecount`
do
    galleryurl="$baseurl$pageadd$I"
    echo "$galleryurl"
    get_gallery
    # download_gallery
done

# return to default ifs (let's hope this does not break other stuff but otherwise you know what to do!)
IFS=$SAVEIFS 
