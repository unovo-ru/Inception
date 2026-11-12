FROM debian:bookworm-slim

# Install only the packages required by the final NGINX image.
RUN apt-get update \
    && apt-get install -y --no-install-recommends nginx ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY conf/ /etc/nginx/
COPY tools/ /usr/local/bin/

EXPOSE 443
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
