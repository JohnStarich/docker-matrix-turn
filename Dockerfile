FROM coturn/coturn:4.5.2
RUN apt-get update && \
    apt-get install -y dnsutils && \
    apt-get clean autoclean && \
    rm -rf /var/lib/apt/* /var/lib/cache/* /var/lib/log/*


COPY --from=johnstarich/env2config:v0.1.6 /env2config /
ENV E2C_CONFIGS=coturn

ENV COTURN_OPTS_FILE=/etc/turnserver.conf
ENV COTURN_OPTS_FORMAT=ini
ENV COTURN_OPTS_IN_listening-ip=INTERNAL_IP
ENV COTURN_OPTS_IN_relay-ip=INTERNAL_IP
ENV COTURN_OPTS_IN_external-ip=EXTERNAL_IP
ENV COTURN_OPTS_IN_static-auth-secret=SHARED_SECRET
ENV COTURN_OPTS_IN_realm=REALM
ENV COTURN_min-port=65435
ENV COTURN_max-port=65535
ENV COTURN_listening-port=3478
ENV COTURN_use-auth-secret=
ENV COTURN_no-stdout-log=
ENV COTURN_log-file=stdout

ENTRYPOINT ["/entrypoint.sh"]
COPY entrypoint.sh /
