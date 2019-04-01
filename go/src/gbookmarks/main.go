package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"

	"gopkg.in/coryb/yaml.v2"
)

func main() {
	contents, err := ioutil.ReadFile(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}

	var bookmarks []struct {
		Title string `json:"title" yaml:"title"`
		URL   string `json:"item" yaml:"url"`
	}

	err = yaml.Unmarshal(contents, &bookmarks)
	if err != nil {
		log.Fatal(err)
	}

	encoded, err := json.Marshal(bookmarks)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println(string(encoded))
}
