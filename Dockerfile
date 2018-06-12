FROM asciidoctor/docker-asciidoctor:latest

RUN set -x && apk add --no-cache openjdk8
