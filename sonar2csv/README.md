# sonar2csv

`sonar2csv` get [SonarQube](https://www.sonarqube.org/)'s metrics value and output it to .csv.

# Installation

## Build sonar2csv

You need [Go(>=1.8)](https://golang.org) and [Masterminds/glide: Package Management for Golang](https://github.com/Masterminds/glide).

```
glide install
make
```

Get `sonar2csv` binary from `release/` directory.

Write configuration about SonarQube to `config.toml`.

```
[sonarqube]
  url = "http://localhost:9000"
  resource = "063285ca8e14"
  metrics = [
    "lines",
    "bugs",
    "violations"
  ]
```

# Usage

```
sonar2csv -h

  -config string
        config file path (default "config.toml")
  -merge string
        csv file path for merging if you like (default "origin.csv")
  -output string
        output file path (default "output.csv")
```

# Development

You need to install [Go](https://golang.org/dl/) and [Masterminds/glide: Package Management for Golang](https://github.com/Masterminds/glide).

```
# Install glide
go get github.com/Masterminds/glide


# Building `sonar2csv` for all platforms.
git clone https://github.com/FujitsuLaboratories/sonar2csv
cd sonar2csv
glide install
make all
```

## License

This library is distributed under the Apache License Version 2.0 found in the [LICENSE](./LICENSE)
file.
