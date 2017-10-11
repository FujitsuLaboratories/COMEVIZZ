package sonar2csv

import (
	"encoding/csv"
	"os"
)

type CSVWriter struct {
	writer *csv.Writer
}

func NewWriter(path string) (*CSVWriter, error) {
	f, err := os.OpenFile(path, os.O_WRONLY|os.O_CREATE, 0644)
	if err != nil {
		return nil, err
	}
	return &CSVWriter{
		writer: csv.NewWriter(f),
	}, nil
}

func (w *CSVWriter) WriteAll(d []map[string]string) error {
	var header []string
	for k, _ := range d[0] {
		header = append(header, k)
	}
	if err := w.WriteCSV(header); err != nil {
		return err
	}

	for _, e := range d {
		if err := w.WriteCSV(getValues(header, e)); err != nil {
			return err
		}
	}
	return nil
}

func getValues(header []string, m map[string]string) []string {
	var values []string
	for _, k := range header {
		if e, ok := m[k]; ok {
			values = append(values, e)
		} else {
			values = append(values, "")
		}
	}
	return values
}

func (w *CSVWriter) WriteCSV(d []string) error {
	if err := w.writer.Write(d); err != nil {
		return err
	}
	w.writer.Flush()
	return nil
}
