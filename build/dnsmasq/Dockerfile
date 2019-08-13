#FROM jpillora/dnsmasq:1.1
FROM alpine:edge

RUN apk --no-cache  add nano dnsmasq

ADD dnsmasq.conf /etc/

EXPOSE 53 53/udp
ENTRYPOINT ["dnsmasq", "-d"]