FROM alpine:edge

RUN apk --no-cache add dnsmasq

ADD dnsmasq.conf /etc/

EXPOSE 53 53/udp
ENTRYPOINT ["dnsmasq", "-d"]