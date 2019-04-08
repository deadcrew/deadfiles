package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"

	"github.com/docopt/docopt-go"
	"gopkg.in/coryb/yaml.v2"
)

type Bookmark struct {
	Title string `json:"title" yaml:"title"`
	URL   string `json:"item" yaml:"url"`
}

var (
	version = "[manual build]"
	usage   = "gbookmarks " + version + `

Usage:
  gbookmarks [options] <file>
  gbookmarks [options] <file> <url> <title>
  gbookmarks -h | --help
  gbookmarks --version

Options:
  -h --help  Show this screen.
  --version  Show version.
`
)

func main() {
	args, err := docopt.Parse(usage, nil, true, version, false)
	if err != nil {
		panic(err)
	}

	contents, err := ioutil.ReadFile(args["<file>"].(string))
	if err != nil {
		log.Fatal(err)
	}

	var bookmarks []Bookmark

	err = yaml.Unmarshal(contents, &bookmarks)
	if err != nil {
		log.Fatal(err)
	}

	if url, ok := args["<url>"].(string); ok {
		title := args["<title>"].(string)

		bookmarks = append(bookmarks, Bookmark{
			URL:   url,
			Title: title,
		})

		encoded, err := yaml.Marshal(bookmarks)
		if err != nil {
			panic(err)
		}

		err = ioutil.WriteFile(args["<file>"].(string), encoded, 0600)
		if err != nil {
			panic(err)
		}

		os.Exit(0)
	}

	encoded, err := json.Marshal(bookmarks)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println(string(encoded))
}
