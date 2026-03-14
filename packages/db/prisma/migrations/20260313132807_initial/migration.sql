-- CreateTable
CREATE TABLE "events" (
    "id" UUID NOT NULL,
    "client_id" TEXT NOT NULL,
    "event_name" TEXT NOT NULL,
    "owner" UUID NOT NULL,
    "event_date" TIMESTAMP(3) NOT NULL,
    "format" TEXT NOT NULL DEFAULT 'Standard',
    "game" TEXT NOT NULL DEFAULT 'Cardfight!! Vanguard',
    "country" TEXT NOT NULL DEFAULT 'USA',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "event_occured" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "users" (
    "id" UUID NOT NULL,
    "judge_code" TEXT,
    "username" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "judge_level" INTEGER,
    "role" TEXT NOT NULL,
    "languages" JSONB,
    "games" JSONB,
    "email" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "players" (
    "id" UUID NOT NULL,
    "bushinavi" TEXT,
    "username" TEXT NOT NULL,
    "email" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "players_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "infractions" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "infractions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "offenses" (
    "id" UUID NOT NULL,
    "event_id" UUID NOT NULL,
    "player_id" UUID NOT NULL,
    "infraction_id" UUID NOT NULL,
    "judge_id" UUID NOT NULL,
    "table_number" INTEGER,
    "round" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "offenses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "rulings" (
    "id" UUID NOT NULL,
    "title" TEXT NOT NULL,
    "ruling" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "owner" UUID NOT NULL,

    CONSTRAINT "rulings_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "events_client_id_key" ON "events"("client_id");

-- CreateIndex
CREATE UNIQUE INDEX "users_judge_code_key" ON "users"("judge_code");

-- CreateIndex
CREATE UNIQUE INDEX "users_username_key" ON "users"("username");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "players_bushinavi_key" ON "players"("bushinavi");

-- CreateIndex
CREATE UNIQUE INDEX "players_username_key" ON "players"("username");

-- CreateIndex
CREATE UNIQUE INDEX "players_email_key" ON "players"("email");

-- CreateIndex
CREATE UNIQUE INDEX "infractions_name_key" ON "infractions"("name");

-- CreateIndex
CREATE INDEX "offenses_event_id_idx" ON "offenses"("event_id");

-- CreateIndex
CREATE INDEX "offenses_player_id_idx" ON "offenses"("player_id");

-- CreateIndex
CREATE INDEX "offenses_infraction_id_idx" ON "offenses"("infraction_id");

-- CreateIndex
CREATE INDEX "offenses_judge_id_idx" ON "offenses"("judge_id");

-- CreateIndex
CREATE UNIQUE INDEX "offenses_event_id_player_id_infraction_id_round_key" ON "offenses"("event_id", "player_id", "infraction_id", "round");

-- AddForeignKey
ALTER TABLE "events" ADD CONSTRAINT "events_owner_fkey" FOREIGN KEY ("owner") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "offenses" ADD CONSTRAINT "offenses_event_id_fkey" FOREIGN KEY ("event_id") REFERENCES "events"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "offenses" ADD CONSTRAINT "offenses_player_id_fkey" FOREIGN KEY ("player_id") REFERENCES "players"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "offenses" ADD CONSTRAINT "offenses_infraction_id_fkey" FOREIGN KEY ("infraction_id") REFERENCES "infractions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "offenses" ADD CONSTRAINT "offenses_judge_id_fkey" FOREIGN KEY ("judge_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rulings" ADD CONSTRAINT "rulings_owner_fkey" FOREIGN KEY ("owner") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
