package utils

import (
	"io"
	"os"
	"path/filepath"
)

func CopyToTemp(src string) (string, error) {
	in, err := os.Open(src)
	if err != nil {
		return "", err
	}
	defer in.Close()

	tmp, err := os.CreateTemp("", "*-"+filepath.Base(src))
	if err != nil {
		return "", err
	}
	defer tmp.Close()

	_, err = io.Copy(tmp, in)
	return tmp.Name(), err
}
