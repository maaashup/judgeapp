import { Hono } from 'hono'
import { serve } from '@hono/node-server'
import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()
const app = new Hono()

app.get('/health', async (c) => {
  await prisma.$queryRaw`SELECT 1`
  return c.json({ ok: true })
})

app.post('/events', async (c) => {
  const body = await c.req.json().catch(() => null) as null | { name?: string }
  const name = body?.name?.trim() || 'Untitled Event'
  const code = Math.random().toString(36).slice(2, 8).toUpperCase()

  const event = await prisma.event.create({ data: { name, code } })
  return c.json(event, 201)
})

serve({ fetch: app.fetch, port: Number(process.env.PORT ?? 3000) })
console.log(`API listening on http://localhost:${process.env.PORT ?? 3000}`)