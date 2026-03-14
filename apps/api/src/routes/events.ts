import { OpenAPIHono, createRoute, z } from '@hono/zod-openapi';
import { prisma } from '../db.js';
import { Event } from '@prisma/client';
import { FORMATS, GAMES, COUNTRIES } from '../constants/eventEnums.js';

export const eventsRouter = new OpenAPIHono();

const EventSchema = z.object({
  id: z.string().uuid(),
  clientId: z.string(),
  eventName: z.string(),
  ownerId: z.string().uuid(),
  eventDate: z.string(),
  format: z.string(),
  game: z.string(),
  country: z.string(),
  createdAt: z.string(),
  eventOccured: z.boolean(),
});

const CreateEventBody = z.object({
  clientId: z.string().min(1, 'Client ID is required'),
  eventName: z.string().min(1, 'Event Name is required'),
  eventDate: z.iso.datetime('Must be a valid ISO DateTime'),
  format: z.enum(FORMATS),
  game: z.enum(GAMES),
  country: z.enum(COUNTRIES),
});

const mapEvent = (e: Event) => ({
  id: e.id,
  clientId: e.clientId,
  eventName: e.eventName,
  ownerId: e.ownerId,
  eventDate: e.eventDate.toISOString(),
  format: e.format,
  game: e.game,
  country: e.country,
  createdAt: e.createdAt.toISOString(),
  eventOccured: e.eventOccured,
});

eventsRouter.openapi(
  createRoute({
    method: 'get',
    path: '/events',
    responses: {
      200: {
        content: { 'application/json': { schema: z.array(EventSchema) } },
        description: 'List of events',
      },
    },
  }),
  async c => {
    const events = await prisma.event.findMany({ orderBy: { eventDate: 'desc' } });
    return c.json(events.map(mapEvent), 200);
  },
);

eventsRouter.openapi(
  createRoute({
    method: 'post',
    path: '/events',
    request: { body: { content: { 'application/json': { schema: CreateEventBody } } } },
    responses: {
      201: {
        content: { 'application/json': { schema: EventSchema } },
        description: 'Event created',
      },
    },
  }),
  async c => {
    const body = c.req.valid('json');
    let user = await prisma.user.findFirst(); // Scaffolding helper
    if (!user)
      user = await prisma.user.create({
        data: { username: 'default_judge', password: 'hash', role: 'admin', email: 'a@b.com' },
      });

    const event = await prisma.event.create({
      data: { ...body, ownerId: user.id, eventDate: new Date(body.eventDate) },
    });
    return c.json(mapEvent(event), 201);
  },
);

eventsRouter.openapi(
  createRoute({
    method: 'put',
    path: '/events/{id}',
    request: {
      params: z.object({ id: z.string().uuid() }),
      body: {
        content: { 'application/json': { schema: CreateEventBody.omit({ clientId: true }) } },
      },
    },
    responses: {
      200: {
        content: { 'application/json': { schema: EventSchema } },
        description: 'Event updated',
      },
    },
  }),
  async c => {
    const { id } = c.req.valid('param');
    const body = c.req.valid('json');

    const event = await prisma.event.update({
      where: { id },
      data: { ...body, eventDate: new Date(body.eventDate) },
    });
    return c.json(mapEvent(event), 200);
  },
);

eventsRouter.openapi(
  createRoute({
    method: 'delete',
    path: '/events/{id}',
    request: { params: z.object({ id: z.string().uuid() }) },
    responses: {
      200: {
        content: { 'application/json': { schema: z.object({ success: z.boolean() }) } },
        description: 'Event deleted',
      },
    },
  }),
  async c => {
    const { id } = c.req.valid('param');
    await prisma.event.delete({ where: { id } });
    return c.json({ success: true }, 200);
  },
);
