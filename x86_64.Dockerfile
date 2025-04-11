FROM ubuntu:24.04

RUN apt-get update -yq && \
    apt-get install -yq ca-certificates curl && \
    rm -rf /var/lib/apt/lists/*

RUN curl -L -o /bin/lightpanda https://github.com/lightpanda-io/browser/releases/download/nightly/lightpanda-x86_64-linux && \
    chmod a+x /bin/lightpanda

EXPOSE 9222/tcp

CMD ["/bin/lightpanda", "serve", "--host", "0.0.0.0", "--port", "9222"] 