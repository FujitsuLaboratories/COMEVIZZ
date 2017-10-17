# Documentation for COMEVIZZ

## Prerequires

You need to install for the followings.

* [Node.js](https://nodejs.org/ja/)
* [Yarn](https://yarnpkg.com/lang/en/)
* (Option)[Calibre](https://calibre-ebook.com/download)
  * If you generate document as PDF format, you need `ebook-convert` included `Calibre`

## Generating documents

```
cd gitbook
yarn global add gitbook-cli
yarn install
```

### Generating HTML Documents

```
gitbook build
```

### Runnning gitbook server

```
gitbook serve
```

### Generating PDF documents

```
gitbook pdf
```

## Generating by Docker

You can run `gitbook` in Docker container.

At first, you should greate Docker image.

```
docker build -t comevizz-doc --build-arg http_proxy=$http_proxy --build-arg https_proxy=$https_proxy .
```

### Generating HTML documents

```
docker run --rm -v $PWD/gitbook:/srv/gitbook comevizz-doc
```

### Running gitbook server

```
docker run --rm -v $PWD/gitbook:/srv/gitbook -p 4000:4000 comevizz-doc serve
```

### Generating PDF documents

```
docker run --rm -v $PWD/gitbook:/srv/gitbook comevizz-doc pdf
```
