FROM debian:bookworm-slim

# MariaDB initialization and hardening will be added in the implementation phase.
RUN apt-get update \
    && apt-get install -y --no-install-recommends mariadb-server \
    && rm -rf /var/lib/apt/lists/*

COPY conf/ /etc/mysql/
COPY tools/ /usr/local/bin/

EXPOSE 3306
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
