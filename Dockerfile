FROM golang:1.10.0 as builder

WORKDIR /go/src/github.com/bitly/oauth2_proxy
COPY . .
RUN make clean build

# https://github.com/a5huynh/oauth2_proxy/blob/master/Dockerfile
FROM debian:stable-slim
COPY --from=builder /go/src/github.com/bitly/oauth2_proxy/build/oauth2_proxy /bin/oauth2_proxy
RUN chmod +x /bin/oauth2_proxy

RUN apt-get update -y && apt-get install -y ca-certificates

EXPOSE 8080 4180
ENTRYPOINT [ "/bin/oauth2_proxy" ]
CMD [ "--upstream=http://0.0.0.0:8080/", "--http-address=0.0.0.0:4180" ]
