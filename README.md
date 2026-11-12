*This project has been created as part of the 42 curriculum by unovo-ru.*

# Inception

## Description
Inception is a 42 School system administration project focused on designing and running a secure multi-service infrastructure inside a Virtual Machine using Docker and Docker Compose.  
The goal is to build each required service from custom Dockerfiles (without prebuilt DockerHub app images and without `latest`) and connect them through an isolated architecture with persistent storage.

### Architecture (ASCII)
```text
[Client Browser]
      |
      | HTTPS (TLSv1.2 / TLSv1.3)
      v
+-------------------+
|   NGINX :443      |
| (single entrypoint)|
+---------+---------+
          |
          | internal docker network
          v
+-------------------+        +-------------------+
| WordPress +       | <----> | MariaDB :3306     |
| PHP-FPM :9000     |        | (DB container)    |
+---------+---------+        +---------+---------+
          |                            |
          |                            |
          v                            v
 [wp_data named volume]        [db_data named volume]
          \______________________/ 
          persisted at /home/unovo-ru/data on host
```

## Project Description & Design Choices
This repository is structured to keep orchestration, images, and configuration clearly separated:

- `Makefile`: standard lifecycle commands (`make`, `make down`, `make clean`, `make fclean`)
- `srcs/docker-compose.yml`: service orchestration, named volumes, and dedicated network
- `srcs/requirements/*`: one folder per service (`nginx`, `wordpress`, `mariadb`) with Dockerfiles and service-specific config/scripts

### Technical Choices Comparison

#### Virtual Machines vs Docker
| Topic | Virtual Machines | Docker Containers | Choice for Inception |
|---|---|---|---|
| Isolation | Full OS per VM | Process-level isolation with namespaces/cgroups | Docker in a VM |
| Resource usage | Higher CPU/RAM footprint | Lightweight and fast startup | Better density for multi-service stack |
| Reproducibility | Heavier image lifecycle | Declarative builds via Dockerfiles | Required by subject |

#### Secrets vs Environment Variables
| Topic | Environment Variables | Docker Secrets | Practical use |
|---|---|---|---|
| Simplicity | Easy to inject via `.env` | Slightly more setup | `.env` mandatory baseline |
| Sensitive data exposure | Can appear in process env/logs | Mounted as files with controlled scope | Secrets recommended for passwords/keys |
| Subject alignment | Required for configuration | Good security hardening | Use both where appropriate |

#### Docker Network vs Host Network
| Topic | Dedicated Docker Network | Host Network | Choice |
|---|---|---|---|
| Isolation | Service-to-service isolation | Shares host network namespace | Dedicated bridge network |
| Port control | Explicit publishing (`443` only) | Less granular | Matches subject restrictions |
| Security posture | Reduced attack surface | Broader exposure | Safer default |

#### Docker Volumes vs Bind Mounts
| Topic | Docker Named Volumes | Bind Mounts | Choice |
|---|---|---|---|
| Management | Docker-managed lifecycle | Host-path coupled | Named volumes required |
| Portability | More consistent across hosts | Host path differences | Better reproducibility |
| Subject rules | Allowed and expected | Explicitly forbidden for this project | Named volumes only |

## Instructions

### Prerequisites
- Linux VM available for the project
- Docker Engine + Docker Compose plugin installed
- `make` installed
- `/etc/hosts` entry configured:

```text
127.0.0.1 unovo-ru.42.fr
```

### Environment setup
1. Copy the environment template:
   ```bash
   cp srcs/.env.example srcs/.env
   ```
2. Fill all required variables in `srcs/.env`.
3. (Recommended) create `secrets/` files for credentials and keep them out of Git.

### Build and run
From repository root:

```bash
make        # build and start infrastructure
make down   # stop and remove containers/network
make clean  # stop and remove containers + named volumes
make fclean # clean + docker system prune -af
```

## Resources
- Docker Docs: https://docs.docker.com/
- Docker Compose Docs: https://docs.docker.com/compose/
- NGINX Docs: https://nginx.org/en/docs/
- MariaDB Docs: https://mariadb.com/kb/en/documentation/
- WP-CLI Docs: https://wp-cli.org/

### AI Usage Disclosure
AI assistance was used to draft the initial repository documentation structure and to review wording/syntax clarity.  
All implementation decisions, architecture validation against the subject constraints, and technical understanding remain under direct author control.
