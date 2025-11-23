package main

import (
	"fmt"

	"github.com/kallebysantos/meow/src/meow/internal/workers"
)

func main() {
	fmt.Println("Starting project...")

	workers.CreateVM()
}
