FROM fellah/gitbook

ARG http_proxy
ARG https_proxy

RUN apt update && apt install -y calibre
RUN npm install -g gitbook-plugin-katex gitbook-plugin-mermaid-gb3

ENTRYPOINT ["/usr/local/bin/gitbook"]
CMD ["pdf", "./", "./document.pdf"]
