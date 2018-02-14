package util

import (
	"log"

	"github.com/BurntSushi/toml"
)

type Config struct {
	Sonarqube SonarSetting
	File      Files
}

type SonarSetting struct {
	URL      string
	Resource string
	Branch   string
	Metrics  []string
}

type Files struct {
	Origin string
	Output string
}

func ReadConf(path string) Config {
	var config Config
	if _, err := toml.DecodeFile(path, &config); err != nil {
		log.Fatal(err)
	}
	return config
}
