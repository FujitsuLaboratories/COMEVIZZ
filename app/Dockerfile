FROM rocker/r-base

ARG http_proxy
ARG https_proxy
RUN apt-get update && apt-get install --no-install-recommends -y \
  curl \
  pkg-config \
  libssl-dev \
  libcurl4-openssl-dev \
  libxml2-dev \
  libnlopt-dev

RUN R -e "install.packages(c('devtools','roxygen2'))"
ADD ./ /usr/local/src
RUN r /usr/local/src/environment.R

ENTRYPOINT ["r", "-p", "/usr/local/src/run.R"]
EXPOSE 3838
