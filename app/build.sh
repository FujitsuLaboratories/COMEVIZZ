sudo docker build \
  --build-arg http_proxy=$http_proxy \
  --build-arg https_proxy=$http_proxy \
  -t comevizz:`git log --pretty=format:"%h" -1` \
  .
