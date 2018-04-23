FROM rocker/rstudio

ARG http_proxy
ARG https_proxy

RUN apt update && apt install -y \
  libnlopt-dev \
  libxml2-dev
RUN mkdir -p /home/rstudio/scripts \
  & chown rstudio:rstudio /home/rstudio/scripts
RUN R -e "install.packages(c('devtools', 'roxygen2'))"
