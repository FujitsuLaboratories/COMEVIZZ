# sonar2csv 

## sonar2csvとは {#intro}

`sonar2csv`はSONARQUBE Software WebAPIからメトリクスデータをCSV形式で取得するコマンドラインツールです.

## 事前準備

事前にメトリクスを収集したいプロジェクトのソースコードに対して、SONARQUBE Software v6.2による解析を行ってください.  
SONARQUBE Softwareでのメトリクス収集方法は [付録: SonarQube起動方法](#sonarqube) を参照してください.

## インストール {#install}

`sonar2csv`の実行ファイルと、それと同じディレクトリにtoml形式の設定ファイルを用意します.  
`sonar2csv`は下記コマンドによりインストールできます（要 [Go(>=1.8)](https://golang.org)）.

```
go get -u github.com/FujitsuLaboratories/COMEVIZZ/sonar2csv
```

### config.toml

config.tomlにはSONARQUBE Softwareの接続情報を下記の設定内容を記述します。 

```
[sonarqube]
  url = "http://localhost:9000"  # 稼働中のSONARQUBE Software ホストIP
  resource = "063285ca8e14"      # CSVとして収集する対象のSONARQUBE Software のリソースID
  metrics = [                    # 収集するSONARQUBE Software のメトリクスKey
    "lines",
    "bugs",
    "violations"
  ]
```

`metrics`に指定するSONARQUBE SoftwareのメトリクスKey名はSONARQUBE Software WebAPIの [GET api/metrics/search](https://sonarqube.com/web_api/api/metrics/search) から確認出来ます.

## 使用方法 {#usage}

`sonar2csv`コマンドを実行すると,`config.toml`に記述したメトリクス情報を`output.csv`ファイルとして出力します.  
toml設定ファイルパスは`-config [path]`で指定できます.  
出力ファイルパスは`-output [path]`で指定できます.


```
sonar2csv -h

  -config string
        config file path (default "config.toml")
  -merge string
        csv file path for merging if you like (default "origin.csv")
  -output string
        output file path (default "output.csv")
```

既にメトリクスCSVファイルが存在する場合,既存のメトリクスCSVファイルとマージすることもできます.  
マージする場合、元のメトリクスCSVファイルを`origin.csv`という名前でsonar2csv実行ディレクトリに配置するか,`-merge [path]`オプションでメトリクスCSVファイルを指定して`sonar2csv`コマンドを実行することにより,マージされたCSVファイルを出力することもできます.


# 付録:SONARQUBE Software起動方法 {#sonarqube}

##　SONARQUBE Software Server

SONARQUBE Softwareサーバーを起動します.  
手順については公式サイトを参考にしてください.
* [Installing the Server - SonarQube Documentation - SonarQube](https://docs.sonarqube.org/display/SONAR/Installing+the+Server)

Dockerを使用できる場合、SONARQUBE Software公式のDokcerイメージを利用すると便利です.
[library/sonarqube - Docker Hub](https://hub.docker.com/_/sonarqube/)

## SonarQube Scanner

SONARQUBE Softwareで解析を行うためのサポートツールである `SonarQube Scanner`&copy; を利用して、ソースコードの解析を実施します.
MavenやJenkinsからもSONARQUBE Softwareの解析を行えるため、既にSONARQUBE Softwareでの解析を行うことができている場合は `SonarQube Scanner` を使用する必要はありません.
[Analyzing Source Code - Scanners - SonarQube](https://docs.sonarqube.org/display/SCAN/Analyzing+Source+Code#AnalyzingSourceCode-RunningAnalysis)

`SonarQube Scanner`の使い方については下記を参照してください.
* [Analyzing with SonarQube Scanner - Scanners - SonarQube](https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner)

