package main

import (
	"log"
	"os"
	"time"

	"github.com/c2h5oh/datasize"
)

func main() {
	var v datasize.ByteSize
	err := v.UnmarshalText([]byte(os.Args[1]))
	if err != nil {
		log.Fatal(err)
	}

	bytes := v.Bytes()

	buffer := make([]byte, bytes)
	for i := 0; i < int(bytes); i++ {
		buffer[i] = 0x1
		if i%(1024*1024*1024) == 0 {
			log.Printf("%dGB consumed\n", i/1024/1024/1024)
		}
	}

	log.Println("Consumed RAM, waiting for death")

	time.Sleep(time.Hour * 24)

	_ = buffer
}
