# sonar2csv

## About `sonar2csv` {#intro}

`sonar2csv` is Command Line Tool to obtain metrics data in form of csv through SONARQUBE Software WebAPI.  

## Prerequires

It is necessary to analyze your source code by SONARQUBE Software v6.2 in advance.  
See [Appendix: How to use SONARQUBE Software](#sonarqube) about how to analyze by SONARQUBE Software.  

## Install `sonar2csv` {#install}

`sonar2csv` needs executable binary and config file named `condig.toml`.  
You can install `sonar2csv` by the following command (Need [Go(>=1.8)](https://golang.org)).

```
go get -u github.com/FujitsuLaboratories/COMEVIZZ/sonar2csv
```

### config.toml

You need to write `config.toml` about infomation of SONARQUBE Software.  

```
[sonarqube]
  url = "http://localhost:9000"  # Host of SONARQUBE Software;
  resource = "063285ca8e14"      # ResourceID of the project on SONARQUBE Software;
  metrics = [                    # Key of SONARQUBE Software's metrics. See [GET api/metrics/search](https://sonarqube.com/web_api/api/metrics/search) about more.
    "lines",
    "bugs",
    "violations"
  ]
```

## Usage of `sonar2csv` {#usage}

By executing `sonar2csv` command, you will get the file named `output.csv` containing metrics values specified in `config.toml`.  
`sonar2csv` has command line options as follows.

```
sonar2csv -h

  -config string
        config file path (default "config.toml")
  -merge string
        csv file path for merging if you want to (default "origin.csv")
  -output string
        output file path (default "output.csv")
```

You can merge existing metrics data csv file and metrics value measured by SONARQUBE Software. To do so, you need to place metrics data csv file named `origin.csv` in the same directory of `sonar2csv` binary, or specify the path for the csv file to which you want to merge the metrics data.  

# Appendix: How to use SONARQUBE Software {#sonarqube}

## SONARQUBE Software Server

First, Run SONARQUBE Software server.
See official document for further information.
* [Installing the Server - SonarQube Documentation - SonarQube](https://docs.sonarqube.org/display/SONAR/Installing+the+Server)

We recommend to use Docker because it is easy to deploy.  
[library/sonarqube - Docker Hub](https://hub.docker.com/_/sonarqube/)

## SonarQube Scanner

`SonarQube Scanner`&copy; is supporting tool to analyze source code by SONARQUBE Software.  
If you have already analyzed your source code by Maven or Gradle plugin for SONARQUBE Software, You do not need to use `SonarQube Scanner`.  

[Analyzing Source Code - Scanners - SonarQube](https://docs.sonarqube.org/display/SCAN/Analyzing+Source+Code#AnalyzingSourceCode-RunningAnalysis)

See [Analyzing with SonarQube Scanner - Scanners - SonarQube](https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner) to find how to use SonarQube Scanner.
