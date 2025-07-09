# Development Setup

## Requirements: Installing Deno and Docker

Before you start, make sure you have both **Deno** and **Docker** installed on
your system.

### Install Deno

- Official instructions: https://deno.com/manual/getting_started/installation
- Quick install (macOS/Linux):
  ```sh
  curl -fsSL https://deno.land/install.sh | sh
  ```
- For Windows, use the
  [Deno installer](https://deno.com/manual/getting_started/installation#using-windows-installer)
  or [Scoop](https://scoop.sh/).
- After installation, check:
  ```sh
  deno --version
  ```

### Install Docker

- Download Docker Desktop for
  [Mac](https://www.docker.com/products/docker-desktop/) or
  [Windows](https://www.docker.com/products/docker-desktop/).
- For Linux, follow the
  [official Docker Engine install guide](https://docs.docker.com/engine/install/).
- After installation, check:
  ```sh
  docker --version
  docker compose version
  ```

Both **Deno** and **Docker** must be installed before running the project.

## Running SurrealDB with Docker Compose

This project uses Docker Compose to run SurrealDB for local development.
Credentials and configuration are managed via environment variables for security
and flexibility. Persistent storage is enabled by default using a Docker-managed
volume.

### 1. Create a `.env` file

Copy the example below to a file named `.env` in the project root (do NOT commit
real secrets):

```env
SURREALDB_USER=your_secure_user
SURREALDB_PASS=your_secure_password
SURREALDB_LOG=info
SURREALDB_PORT=8000
```

### 2. Start SurrealDB (Detached Mode)

Start SurrealDB in the background (recommended):

```sh
docker compose up -d
```

- SurrealDB will be available at `ws://localhost:${SURREALDB_PORT}` or
  `http://localhost:${SURREALDB_PORT}`.
- To view logs, run:
  ```sh
  docker compose logs -f
  ```
- To stop and remove the service, run:
  ```sh
  docker compose down
  ```

### 3. Persistent Storage

- Data is stored in the `mydata` directory in your project root, which is
  mounted into the container.
- This means your database persists across container restarts and
  `docker compose down/up` cycles.
- To inspect the data, look in the `mydata` directory.
- To remove all data (dangerous!):
  ```sh
  docker compose down -v
  rm -rf mydata/*
  ```

### 4. Security Best Practices

- **Never commit your `.env` file** with real secrets to version control.
- Use a `.env.example` with placeholder values for contributors.
- For production, use a secrets manager or CI/CD environment variables.

---

See `docker-compose.yml` for service configuration details. The `version`
attribute is no longer required or present in the Compose file.
