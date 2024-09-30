ARG LIGHTTPD_VERSION=1.4.76
FROM jitesoft/lighttpd:$LIGHTTPD_VERSION

RUN apk add bash jq && rm -rf /var/cache/apk
COPY --chown=root:root derp-remap.sh /usr/bin/
COPY --chown=root:root 001-cgi.conf /etc/lighttpd/conf.d/
