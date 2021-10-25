# imgur_dl.sh

## how to use
1. give the script rights to execute on your system `chmod +x imgur.sh`
2. compile the go tokenscript with `go build tokenscript.go`
3. make that programm executable on your system `chmod +x tokenscript`
4. run the script `./imgur_dl.sh $theimgurlink`

## dependencies
- golang
- curl
- jq
- wget (for better "reconnect/retry" downloads of actual files)
