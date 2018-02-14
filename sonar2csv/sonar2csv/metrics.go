package sonar2csv

import (
	"log"
	"os"

	"github.com/FujitsuLaboratories/COMEVIZZ/sonar2csv/util"
)

// sonarResponse は Sonar WebAPI - /api/resource のレスポンスのモデル
type SonarResponse struct {
	Component    Component `json:"component"`
}

type Component struct {
	ID           string    `json:"id"`
	Key          string    `json:"key"`
	Name         string    `json:"name"`
	Qualifier    string    `json:"qualifier"`
	Branch       string    `json:"branch"`
	Msr          []Metrics `json:"measures"`
}

// Metrics はSonar WebAPI - /api/measures/componentのレスポンスのうち、メトリクスに関するモデル
type Metrics struct {
	Key     string  `json:"metric"`
	Val     string  `json:"value"`
}

func (s *SonarResponse) MergeMetrics(originFile string, appendix map[string]string) ([]map[string]string, error) {
	vals := map[string]string{}
	for _, v := range s.Component.Msr {
		vals[v.Key] = v.Val
	}
	for k, v := range appendix {
		vals[k] = v
	}
	if len(originFile) != 0 && existsFile(originFile) {
		log.Print("Merging metrics data to origin csv file: ", originFile)
		m, err := util.AppendToCSV(originFile, vals)
		if err != nil {
			return nil, err
		}
		return m, nil
	} else {
		return []map[string]string{vals}, nil
	}
}

func existsFile(path string) bool {
	_, err := os.Stat(path)
	return err == nil
}
