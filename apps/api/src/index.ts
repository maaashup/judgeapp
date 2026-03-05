import { serve } from '@hono/node-server'
import { PrismaClient } from '@prisma/client'
import { OpenAPIHono, createRoute, z } from '@hono/zod-openapi'
import { Scalar } from '@scalar/hono-api-reference'
import { Pool } from 'pg'
import { PrismaPg } from '@prisma/adapter-pg'

const pool = new Pool({ connectionString: process.env.DATABASE_URL })
const adapter = new PrismaPg(pool)
const prisma = new PrismaClient({ adapter })

const app = new OpenAPIHono()

const healthRoute = createRoute({
  method: 'get',
  path: '/health',
  responses: {
    200: {
      content: {
        'application/json': { schema: z.object({ ok: z.boolean() }) },
      },
      description: 'Check API health',
    },
  },
})

app.openapi(healthRoute, async (c) => {
  await prisma.$queryRaw`SELECT 1`
  return c.json({ ok: true }, 200)
})

const createEventRoute = createRoute({
  method: 'post',
  path: '/events',
  request: {
    body: {
      content: {
        'application/json': {
          schema: z.object({
            clientId: z.string().min(1, "Client ID is required"),
            eventName: z.string().min(1, "Event Name is required"),
            ownerId: z.uuid("Owner ID must be a valid User UUID"),
            eventDate: z.iso.datetime("Must be a valid ISO DateTime"),
          }),
        },
      },
    },
  },
  responses: {
    201: {
      content: {
        'application/json': {
          schema: z.object({
            id: z.string().uuid(),
            clientId: z.string(),
            eventName: z.string(),
            ownerId: z.string().uuid(),
            eventDate: z.string(),
            createdAt: z.string(),
            eventOccured: z.boolean(),
          }),
        },
      },
      description: 'Event created successfully',
    },
  },
})

app.openapi(createEventRoute, async (c) => {
  const body = c.req.valid('json')

  const event = await prisma.event.create({
    data: {
      clientId: body.clientId,
      eventName: body.eventName,
      ownerId: body.ownerId,
      eventDate: new Date(body.eventDate),
    },
  })

  return c.json({
    ...event,
    eventDate: event.eventDate.toISOString(),
    createdAt: event.createdAt.toISOString()
  }, 201)
})

app.doc('/openapi.json', {
  openapi: '3.0.0',
  info: { version: '1.0.0', title: 'Judge App API' },
})

app.get(
  '/reference',
  Scalar({
    theme: 'default',
    url: '/openapi.json'
  })
)

const port = Number(process.env.PORT ?? 3000)
serve({ fetch: app.fetch, port })