# Judge App

Monorepo for the judge app stack

- **API**: Hono
- **DB**: Postgres
- **ORM**: Prisma
- **Mobile**: Flutter

## Requirements

- Docker Desktop
- VS Code + Dev Containers extension

## Repo structure

- `apps/api` - Hono API
- `apps/mobile` - Flutter app
- `packages/db` - Prisma schema, migrations, and generated client

## Quickstart (dev container)

Open repo in VS Code

Run `Dev Containers: Reopen in Container`

    This repo uses a compose-based devcontainer. When the container starts, Docker will bring up:
    - `app` (the devcontainer you attach to)
    - `db` (Postgres)

Create env file

```sh
cp .env.example .env
```

Install and migrate database

```bash
pnpm install
pnpm db:migrate
pnpm db:generate
```

Preferably, run app and API separately for hot reloading

```bash
pnpm dev:api
pnpm dev:mobile
```

Or run development mode in parallel

```bash
pnpm dev
```

- API: [http://localhost:3000](http://localhost:3000)
- Mobile: [http://localhost:8100](http://localhost:8100)
  - [Dart Debug Extension](https://chromewebstore.google.com/detail/dart-debug-extension/eljbmlghnomdjgdjmbdekegdkbabckhm) should be installed for hot reload

## Available scripts (run in root)

| Command             | Description                            |
| :------------------ | :------------------------------------- |
| `pnpm dev`          | Starts API and Mobile apps in parallel |
| `pnpm dev:api`      | Starts only the Hono API               |
| `pnpm dev:mobile`   | Starts only the Flutter app            |
| `pnpm db:migrate`   | Runs Prisma migration                  |
| `pnpm db:reset`     | Resets Prisma migrations               |
| `pnpm db:studio`    | Opens Prisma Studio (GUI for DB)       |
| `pnpm build:mobile` | Builds Flutter APK                     |
