package main

import (
	"bytes"
	"io/ioutil"
	"log"

	"github.com/docopt/docopt-go"
)

var (
	version = "[manual build]"
	usage   = "greplace " + version + `

Just fucking stupid simple multi line greplace.

Usage:
  greplace [options] <from-file> <to-file> <file>...
  greplace -h | --help
  greplace --version

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

	from, err := ioutil.ReadFile(args["<from-file>"].(string))
	if err != nil {
		log.Fatalln(err)
	}

	to, err := ioutil.ReadFile(args["<to-file>"].(string))
	if err != nil {
		log.Fatalln(err)
	}

	for _, filename := range args["<file>"].([]string) {
		contents, err := ioutil.ReadFile(filename)
		if err != nil {
			log.Fatalln(err)
		}

		if bytes.Contains(contents, from) {
			contents = bytes.ReplaceAll(contents, from, to)

			err = ioutil.WriteFile(filename, contents, 0755)
			if err != nil {
				log.Fatalln(err)
			}
		}
	}
}
