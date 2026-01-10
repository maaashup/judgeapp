# Judge App

Monorepo for the judge app stack.

- **API**: Hono (Node.js)
- **DB**: Postgres (Docker)
- **ORM**: Prisma
- **Mobile**: Ionic + Angular (Standalone) + Capacitor

## Requirements

- Docker Desktop
- VS Code + Dev Containers extension
- Node is not required on your host if you use the devcontainer

## Repo structure

- `apps/api` - Hono API (Node.js server)
- `apps/mobile` - Ionic Angular Mobile App (Standalone components)
- `packages/db` - Prisma schema, migrations, and generated client

## Quickstart (dev container)

1) Open repo in VS Code
2) Run: **Dev Containers: Reopen in Container**

    This repo uses a compose-based devcontainer. When the container starts, Docker will bring up:
    - `app` (the devcontainer you attach to)
    - `db` (Postgres), because `app` depends on it

3) Create env file:

```sh
cp .env.example .env
```
4) Install and migrate database:
   ```bash
   pnpm install
   pnpm db:migrate
   pnpm db:generate
   ```
5) Run development mode:
   ```bash
   pnpm dev
   ```
   - API: [http://localhost:3000](http://localhost:3000)
   - Mobile: [http://localhost:8100](http://localhost:8100)

## Available scripts (run in root)

| Command | Description |
| :--- | :--- |
| `pnpm dev` | Starts API and Mobile apps in parallel |
| `pnpm dev:api` | Starts only the Hono API |
| `pnpm dev:mobile` | Starts only the Ionic Angular app |
| `pnpm db:migrate` | Runs Prisma migrations (dev) |
| `pnpm db:studio` | Opens Prisma Studio (GUI for DB) |
| `pnpm build:mobile` | Builds the mobile web assets for production |