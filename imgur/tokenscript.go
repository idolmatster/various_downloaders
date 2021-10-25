package main
  
import (
	"fmt"
	"os"
	"strings"
	"io/ioutil"
)
  
func main() {

	content, err := ioutil.ReadFile("script.js")
    if err != nil {
		// exiting without further error in case of read error
		os.Exit(1)
    }

    // Convert []byte to string and print to screen
    text := string(content)

	// cleverly sclice the script output file
    split := strings.Split(text, "o=\"https://rt.\".concat(\"imgur.com\"),")
	splita := split[1]
	split = strings.Split(splita, "s=\"")
	splita = split[1]
	split = strings.Split(splita, "\"")
	fmt.Println(split[0])
	os.Exit(0)
}
