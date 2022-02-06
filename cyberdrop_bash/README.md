# Cyberdrop Bash Downloader

========== New & Improved ===========
 this version now uses jq instead of
 pup. It's also API based instread
 of based on the web page.
 This enables smart retry and
 preview downloading if the image is
 not available at the moment.
 Bonus better error message!
=====================================

## how to use
./cybash.sh "linktogallery"

## Features

-   Creates Folders with name and id [now samba/windows compatible folder names (hopefully)]
-   atempts redownload ONCE if the there are missing files
-   now downloads previews if the image is not available (better then nothing)
-   does not create temporary files
-   only hits the api once

## dependencies

-   jq
-   wget
-   curl (or just remove the "data donation" feature )
-   other bash + gnu/linux goodness

## the negatives
- over engeneered
- a bit bloated
- no multi gallery or simultanious download
