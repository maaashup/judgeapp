import { OpenAPIHono, createRoute, z } from '@hono/zod-openapi';
import { prisma } from '../db.js';

export const eventsRouter = new OpenAPIHono();

const getEventsRoute = createRoute({
  method: 'get',
  path: '/events',
  responses: {
    200: {
      content: {
        'application/json': {
          schema: z.array(
            z.object({
              id: z.string().uuid(),
              clientId: z.string(),
              eventName: z.string(),
              ownerId: z.string().uuid(),
              eventDate: z.string(),
              createdAt: z.string(),
              eventOccured: z.boolean(),
            }),
          ),
        },
      },
      description: 'List of events',
    },
  },
});

eventsRouter.openapi(getEventsRoute, async c => {
  const events = await prisma.event.findMany({
    orderBy: { eventDate: 'desc' },
  });

  return c.json(
    events.map(e => ({
      ...e,
      eventDate: e.eventDate.toISOString(),
      createdAt: e.createdAt.toISOString(),
    })),
    200,
  );
});

const createEventRoute = createRoute({
  method: 'post',
  path: '/events',
  request: {
    body: {
      content: {
        'application/json': {
          schema: z.object({
            clientId: z.string().min(1, 'Client ID is required'),
            eventName: z.string().min(1, 'Event Name is required'),
            eventDate: z.iso.datetime('Must be a valid ISO DateTime'),
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
});

eventsRouter.openapi(createEventRoute, async c => {
  const body = c.req.valid('json');

  let user = await prisma.user.findFirst();
  if (!user) {
    user = await prisma.user.create({
      data: {
        username: 'default_judge',
        password: 'hashed_password_here',
        role: 'admin',
        email: 'admin@judge.app',
      },
    });
  }

  const event = await prisma.event.create({
    data: {
      clientId: body.clientId,
      eventName: body.eventName,
      ownerId: user.id,
      eventDate: new Date(body.eventDate),
    },
  });

  return c.json(
    {
      ...event,
      eventDate: event.eventDate.toISOString(),
      createdAt: event.createdAt.toISOString(),
    },
    201,
  );
});
