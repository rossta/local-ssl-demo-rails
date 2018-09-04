FROM alpine:3.5

LABEL maintainer "opsxcq@strm.sh"

RUN apk --no-cache add dnsmasq

VOLUME /etc/dnsmasq

EXPOSE 53 53/udp

RUN echo "address=/ross/127.0.0.1" > /etc/dnsmasq.d/dnsmasq-localhost.conf

ENTRYPOINT ["dnsmasq", "-k"]
