package main

import (
	"encoding/json"
	"flag"
	"github.com/FujitsuLaboratories/COMEVIZZ/sonar2csv/sonar2csv"
	"github.com/FujitsuLaboratories/COMEVIZZ/sonar2csv/util"
	"io/ioutil"
	"log"
	"time"
)

var (
	c = flag.String("config", "config.toml", "config file path")
	m = flag.String("merge", "origin.csv", "csv file path for merging if you like")
	o = flag.String("output", "output.csv", "output file path")
)

func main() {
	flag.Parse()

	config := util.ReadConf(*c)

	server, err := sonar2csv.NewServer(config.Sonarqube)
	if err != nil {
		log.Fatal(err)
	}
	resp, err := server.GetResources()
	if err != nil {
		log.Fatal(err)
	}
	defer resp.Body.Close()

	b, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Fatal(err)
	}
	var r sonar2csv.SonarResponse
	json.Unmarshal(b, &r)
	appendix := map[string]string{
		"commit.id": r.Component.ID,
		"url":       r.Component.Name,
		"time":      time.Now().Format("2006-01-02T12:34:56Z"),
	}
	val, err := r.MergeMetrics(*m, appendix)
	if err != nil {
		log.Fatal(err)
	}

	log.Print("Writing metrics csv file: ", *o)
	w, err := sonar2csv.NewWriter(*o)
	if err != nil {
		log.Fatal(err)
	}
	if err := w.WriteAll(val); err != nil {
		log.Fatal(err)
	}
}
