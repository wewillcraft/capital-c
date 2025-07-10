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

Copy the `.env.example` file to `.env` and fill in the values.

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

- Data is stored in the `data` directory in your project root, which is mounted
  into the container.
- This means your database persists across container restarts and
  `docker compose down/up` cycles.
- To inspect the data, look in the `data` directory.
- To remove all data (dangerous!):
  ```sh
  docker compose down -v
  rm -rf data/*
  ```

---

## Database Bootstrapping and Multi-Tenant Setup

After starting SurrealDB, follow these steps to initialize your database and
create your first tenant:

### 1. Apply Global Migrations

This sets up the global schema (users, tenant registry, etc):

```sh
deno task migrate apply global
```

### 2. Create a Root User (Admin)

This will interactively prompt for name, email, and password:

```sh
deno task users create
```

### 3. Create a Tenant and Link to Root User

This creates a new tenant namespace, applies all tenant migrations, and links
the tenant to the root user by email:

```sh
deno task tenants create <name> <display_name> <root_user_email>
# Example:
deno task tenants create example "Example Church" admin@example.com
```

This will:

- Create a new SurrealDB namespace for the tenant
- Insert a tenant record in the global namespace
- Link the root user to the tenant with graph edges
- Apply all tenant migrations to the new namespace
