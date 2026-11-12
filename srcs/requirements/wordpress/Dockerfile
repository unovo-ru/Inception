FROM debian:bookworm-slim

# PHP-FPM and WordPress setup will be added in the implementation phase.
RUN apt-get update \
    && apt-get install -y --no-install-recommends php-fpm php-mysql curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY conf/ /etc/
COPY tools/ /usr/local/bin/

EXPOSE 9000
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
