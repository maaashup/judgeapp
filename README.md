# Judge App

Monorepo for the judge app.

- **API**: Hono (Node.js)
- **DB**: Postgres (Docker)
- **ORM**: Prisma
- **Mobile**: Ionic + Capacitor (to be scaffolded)

## Requirements

- Docker Desktop
- VS Code + Dev Containers extension
- Node is not required on your host if you use the devcontainer

## Repo structure

- `apps/api` – Hono API
- `apps/mobile` - Frontend
- `packages/db` – Prisma schema + client

## Quickstart (dev container)

1) Open repo in VS Code

2) Run: **Dev Containers: Reopen in Container**

    This repo uses a compose-based devcontainer. When the container starts, Docker will bring up:
    - `app` (the devcontainer you attach to)
    - `db` (Postgres), because `app` depends on it

4) Create env file:

```sh
cp .env.example .env
```

5) Install deps + run DB migration + start API:

```sh
pnpm install
pnpm db:migrate
pnpm dev
```

6) Test:

- http://localhost:3000/health

## Notes
### DB connection hostname
When API runs inside the compose/devcontainer network, the DB host is `db`:

`postgresql://...@db:5432/...`