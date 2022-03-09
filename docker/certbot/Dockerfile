FROM certbot/dns-cloudflare

LABEL maintainer="k078264@gmail.com"

RUN apk -U upgrade \
    && apk add curl bash \
    iptables \
    ca-certificates \
    e2fsprogs \
    docker \
    && pip install certbot-dns-cloudflare \
    && rm -rf /var/cache/apk/*

COPY ./gen-ssl.sh /gen-ssl.sh
COPY ./cloudflare.ini /cloudflare.ini

ENTRYPOINT [ "/gen-ssl.sh" ]