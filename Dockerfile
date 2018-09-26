FROM python:3-alpine3.8

ENTRYPOINT [ "certbot" ]
EXPOSE 80 443
VOLUME /etc/letsencrypt /var/lib/letsencrypt
WORKDIR /opt/certbot

COPY CHANGELOG.md README.rst setup.py src/
COPY acme src/acme
COPY certbot src/certbot
COPY certbot-dns-digitalocean src/certbot-dns-digitalocean

RUN apk add --no-cache --virtual .certbot-deps \
        libffi \
        libssl1.0 \
        openssl \
        ca-certificates \
        binutils
RUN apk add --no-cache --virtual .build-deps \
        gcc \
        linux-headers \
        openssl-dev \
        musl-dev \
        libffi-dev \
    && pip install --no-cache-dir \
        --editable /opt/certbot/src/acme \
        --editable /opt/certbot/src \
        --editable /opt/certbot/src/certbot-dns-digitalocean \
    && apk del .build-deps
