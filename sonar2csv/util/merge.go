package util

import (
	"os"

	"github.com/recursionpharma/go-csv-map"
)

func AppendToCSV(csvfile string, d map[string]string) ([]map[string]string, error) {
	// Reading origin csv file
	f, err := os.Open(csvfile)
	if err != nil {
		return nil, err
	}
	reader := csvmap.NewReader(f)
	reader.Columns, err = reader.ReadHeader()
	if err != nil {
		return nil, err
	}
	records, err := reader.ReadAll()
	if err != nil {
		return nil, err
	}

	// merge metrics data
	o, t := findNonDupHeader(records[0], d)
	for _, v := range o {
		d[v] = ""
	}
	for _, v := range records {
		for _, e := range t {
			v[e] = ""
		}
	}
	records = append(records, d)
	return records, nil
}

func findNonDupHeader(oRow, tRow map[string]string) ([]string, []string) {
	var onlyOrigin []string
	var onlyTarget []string

	for k, _ := range oRow {
		if _, ok := tRow[k]; !ok {
			onlyOrigin = append(onlyOrigin, k)
		}
	}
	for k, _ := range tRow {
		if _, ok := oRow[k]; !ok {
			onlyTarget = append(onlyTarget, k)
		}
	}
	return onlyOrigin, onlyTarget
}
