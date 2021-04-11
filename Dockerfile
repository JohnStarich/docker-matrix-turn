FROM coturn/coturn:4.5.2
RUN apt-get update && \
    apt-get install -y dnsutils && \
    apt-get clean autoclean && \
    rm -rf /var/lib/apt/* /var/lib/cache/* /var/lib/log/*

ENTRYPOINT ["/entrypoint.sh"]
COPY entrypoint.sh /
