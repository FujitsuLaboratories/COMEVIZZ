package main

import (
	"encoding/json"
	"flag"
	"github.com/FujitsuLaboratories/sonar2csv/sonar2csv"
	"github.com/FujitsuLaboratories/sonar2csv/util"
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
	var r []sonar2csv.SonarResponse
	json.Unmarshal(b, &r)
	if len(r) != 1 {
		log.Fatal("duplicated or none")
	}

	appendix := map[string]string{
		"commit.id": r[0].Version,
		"url":       "TargetProject1",
		"time":      time.Now().Format("2006-01-02T12:34:56Z"),
	}
	val, err := r[0].MergeMetrics(*m, appendix)
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
