FROM alpine:3.5

LABEL maintainer "ross@rossta.net"

RUN apk --no-cache add dnsmasq

VOLUME /etc/dnsmasq

EXPOSE 53 53/udp

RUN echo "address=/ross/127.0.0.1" > /etc/dnsmasq.d/dnsmasq-localhost.conf

CMD ["dnsmasq"]
