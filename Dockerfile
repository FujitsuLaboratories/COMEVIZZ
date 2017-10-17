FROM ysknmt/docker-gitbook

RUN apt update && apt install -y calibre
RUN npm install -g gitbook-plugin-katex gitbook-plugin-mermaid-gb3

COPY ./gitbook.sh /gitbook.sh

ENTRYPOINT ["/gitbook.sh"]
CMD ["build"]
