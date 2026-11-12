*This project has been created as part of the 42 curriculum by unovo-ru.*

# Inception

Inception is a systems administration project from the 42 curriculum. It builds a small, isolated web infrastructure inside a virtual machine using Docker and Docker Compose. Each required service runs in its own custom image, with persistent data, private networking, TLS termination, and reproducible configuration.

## Description

The infrastructure exposes only HTTPS on port `443`. NGINX terminates TLS and forwards PHP requests to WordPress with PHP-FPM. WordPress uses MariaDB as its database. Persistent data is stored in two Docker named volumes backed by `/home/unovo-ru/data` on the host.

```text
                              Docker network: inception
+--------+       HTTPS :443       +---------+       FastCGI :9000       +------------------+
| Client | ----------------------> |  NGINX | ------------------------> | WordPress/PHP-FPM |
+--------+                         +---------+                           +------------------+
                                        |                                          |
                                        | TLS 1.2/1.3                            | SQL :3306
                                        |                                          v
                                        |                                  +---------------+
                                        |                                  |    MariaDB    |
                                        |                                  +---------------+
                                        |                                          |
                                        |                           +--------------+--------------+
                                        |                           |                             |
                                        v                           v                             v
                              WordPress named volume       MariaDB named volume          /home/unovo-ru/data
```

## Project Description & Design Choices

The repository is deliberately split between orchestration and service implementations:

- `Makefile` provides short, repeatable lifecycle commands.
- `srcs/docker-compose.yml` defines services, the dedicated network, named volumes, secrets, and restart policies.
- `srcs/requirements/` contains one custom build context per service, including its `Dockerfile`, configuration, and startup tools.
- `.env` and `secrets/` are local-only inputs and must never be committed.

### Technical comparison

| Topic | Choice in Inception | Rationale |
| --- | --- | --- |
| Virtual Machines vs Docker | Docker containers inside a VM | Containers isolate each service with less overhead, while the VM provides the required project boundary and reproducible host environment. |
| Secrets vs Environment Variables | Secrets for sensitive values; `.env` for non-secret configuration | Environment variables are convenient for configuration, but Docker secrets avoid exposing passwords in service metadata and process environments where supported. |
| Docker Network vs Host Network | Dedicated user-defined Docker network | Services communicate by container name and only NGINX publishes `443`; host networking would weaken isolation and bypass Docker's network controls. |
| Docker Volumes vs Bind Mounts | Two named volumes mapped to `/home/unovo-ru/data` | Named volumes provide Docker-managed persistence while the host-backed driver options satisfy the required storage location without bind mounts in the Compose service definitions. |

## Instructions

### Prerequisites

- A Linux virtual machine with Docker Engine and the Docker Compose plugin installed.
- GNU Make.
- Sufficient privileges to run Docker, or membership in the `docker` group.
- A local hostname entry mapping `unovo-ru.42.fr` to the VM address, for example:

  ```text
  127.0.0.1 unovo-ru.42.fr
  ```

### Configuration

1. Copy the example environment file:

   ```bash
   cp srcs/.env.example srcs/.env
   ```

2. Review the values in `srcs/.env`, especially the domain, database name, and non-secret usernames.
3. Create the local `secrets/` directory and add the secret files referenced by `docker-compose.yml`. Use one value per file and do not commit them:

   ```bash
   mkdir -p secrets
   printf '%s\n' 'change-me' > secrets/db_root_password.txt
   printf '%s\n' 'change-me' > secrets/db_password.txt
   chmod 600 secrets/*.txt
   ```

4. Ensure the host data directories exist:

   ```bash
   sudo mkdir -p /home/unovo-ru/data/{wordpress,mariadb}
   sudo chown -R "$USER":"$USER" /home/unovo-ru/data
   ```

### Build and run

From the repository root:

```bash
make              # Build images and start the infrastructure
make down         # Stop and remove containers and the network
make clean        # Stop services and remove project containers/volumes
make fclean       # Clean plus remove locally built images and generated data
```

Only NGINX publishes port `443`; WordPress/PHP-FPM and MariaDB remain reachable through the private Docker network. TLS certificates are intentionally local files and are excluded from Git.

## Resources

- [Docker Engine documentation](https://docs.docker.com/engine/)
- [Docker Compose documentation](https://docs.docker.com/compose/)
- [NGINX documentation](https://nginx.org/en/docs/)
- [MariaDB documentation](https://mariadb.com/kb/en/documentation/)
- [WP-CLI documentation](https://make.wordpress.org/cli/handbook/)
- [42 Inception subject](https://cdn.intra.42.fr/pdf/pdf/133196/en.subject.pdf)

### Use of AI

AI tools were used during the initial project setup to help structure the documentation, draft neutral template files, and review Compose and Markdown syntax. The author remains responsible for the architecture, implementation, security decisions, testing, and complete technical understanding of the infrastructure. AI-generated suggestions are reviewed and adapted before being incorporated into the project.
