# COMEVIZZ

COMEVIZZ is **CO**de **ME**trics **VIZ**ualization tool with **Z**-score.
You can see the Z-Score of your source code and the distributions of souce code metrics of a lot of software project.

![screenshot](https://github.com/FujitsuLaboratories/comevizz/blob/gh-pages/gitbook/ja/docs/comevizz/images/comevizz_zscore_select_sets.png)

## Usage

See [documentation](https://FujitsuLaboratories.github.io/comevizz).

### Runnning comevizz by docker-compose

You need to install [Docker](https://www.docker.com/) and [Docker Compose](https://docs.docker.com/compose/).

```
// If your environments are in company proxy, you must set env `http_proxy`, `https_proxy`.
export http_proxy=http://user:pass@proxy.example.com:8080
export https_proxy=http://user:pass@proxy.example.com:8080

docker-compose up -d
```

Then access to `http://${host}:3838`.

## Development

### Developers Machine Setup

It had better to use [docker-compose](https://docs.docker.com/compose/).

```
docker-compose -f docker-compose-dev.yml up -d
```

Then access to `http://${host}:8787` and input the following auth.
```
Username: rstudio
Password: rstudio
```

In r-studio's console,

```
// If your network are in proxy, you must set env `http_proxy`, `https_proxy`.
Sys.setenv("http_proxy"="http://user:pass@proxy.example.com:8080")
Sys.setenv("https_proxy"="http://user:pass@proxy.example.com:8080")

devtools::install_deps()
devtools::load_all()
library(comevizz)
comevizz::run()
```

Then you can access comevizz app.

## License

This library is distributed under the Apache License Version 2.0 found in the [LICENSE](./LICENSE)
file.