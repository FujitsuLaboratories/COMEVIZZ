package sonar2csv

import (
	"log"
	"os"
	"strconv"

	"github.com/FujitsuLaboratories/COMEVIZZ/sonar2csv/util"
)

// sonarResponse は Sonar WebAPI - /api/resource のレスポンスのモデル
type SonarResponse struct {
	ID           int       `json:"id"`
	UUID         string    `json:"uuid"`
	Key          string    `json:"key"`
	Name         string    `json:"name"`
	Scope        string    `json:"scope"`
	Qualifier    string    `json:"qualifier"`
	Date         string    `json:"date"`
	CreationDate string    `json:"creationDate"`
	Lname        string    `json:"lname"`
	Version      string    `json:"version"`
	Msr          []Metrics `json:"msr"`
}

// Metrics はSonar WebAPI - /api/resourceのレスポンスのうち、メトリクスに関するモデル
type Metrics struct {
	Key     string  `json:"key"`
	Val     float64 `json:"val"`
	Frmtval string  `json:"frmt_val"`
}

func (s *SonarResponse) MergeMetrics(originFile string, appendix map[string]string) ([]map[string]string, error) {
	vals := map[string]string{}
	for _, v := range s.Msr {
		vals[v.Key] = strconv.FormatFloat(v.Val, 'f', -2, 64)
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
