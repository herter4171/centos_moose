FROM alpine

WORKDIR /app
COPY . /app

RUN apk add git curl --no-cache

CMD ["/bin/ash", "/app/run_downloader.sh"]

