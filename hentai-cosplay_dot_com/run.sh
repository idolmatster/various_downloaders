#!/bin/dash
ext=".jpg"
altext=".png"
text=".gif"
agent="Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36"

for k in $(jq '.arr | keys | .[]' copy.json); do
    value=$(jq ".arr[$k]" copy.json);
    
    arg1=$(jq -r '.arg1' <<< "$value" )
    link=$(jq -r '.link' <<< "$value" )
    high=$(jq -r '.high' <<< "$value" )
    
    mkdir "${arg1}"
    cd "${arg1}"
    for i in `seq ${high}`
    do
        sleep 1
        wget -c "${link}${i}${ext}" --user-agent="${agent}" || wget -c "${link}${i}${altext}" --user-agent="${agent}" || wget -c "${link}${i}${text}" --user-agent="${agent}"
    done
    cd ..

done | column -t -s$'\t'
