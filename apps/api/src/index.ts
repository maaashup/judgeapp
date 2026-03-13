import { serve } from '@hono/node-server';
import { OpenAPIHono, createRoute, z } from '@hono/zod-openapi';
import { Scalar } from '@scalar/hono-api-reference';
import { cors } from 'hono/cors';

import { prisma } from './db.js';
import { eventsRouter } from './routes/events.js';

const app = new OpenAPIHono();

app.use('*', cors());

const healthRoute = createRoute({
  method: 'get',
  path: '/health',
  responses: {
    200: {
      content: { 'application/json': { schema: z.object({ ok: z.boolean() }) } },
      description: 'Check API health',
    },
  },
});

app.openapi(healthRoute, async c => {
  await prisma.$queryRaw`SELECT 1`;
  return c.json({ ok: true }, 200);
});

app.route('/', eventsRouter);

app.doc('/openapi.json', {
  openapi: '3.0.0',
  info: { version: '1.0.0', title: 'Judge App API' },
});
app.get('/reference', Scalar({ theme: 'default', url: '/openapi.json' }));

const port = Number(process.env.PORT ?? 3000);
serve({ fetch: app.fetch, port });
