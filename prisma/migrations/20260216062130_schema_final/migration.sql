-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password_hash" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "monitors" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "interval_seconds" INTEGER NOT NULL DEFAULT 10,
    "expected_status_code" INTEGER NOT NULL DEFAULT 200,
    "max_latency_ms" INTEGER NOT NULL DEFAULT 5000,
    "consecutive_failures" INTEGER NOT NULL DEFAULT 0,
    "is_down" BOOLEAN NOT NULL DEFAULT false,
    "last_checked_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "monitors_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ping_results" (
    "id" TEXT NOT NULL,
    "monitor_id" TEXT NOT NULL,
    "status_code" INTEGER,
    "latency_ms" INTEGER,
    "success" BOOLEAN NOT NULL,
    "error_message" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ping_results_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "incidents" (
    "id" TEXT NOT NULL,
    "monitor_id" TEXT NOT NULL,
    "started_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "resolved_at" TIMESTAMP(3),
    "notification_status" TEXT NOT NULL DEFAULT 'pending',

    CONSTRAINT "incidents_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE INDEX "monitors_user_id_idx" ON "monitors"("user_id");

-- CreateIndex
CREATE INDEX "monitors_active_idx" ON "monitors"("active");

-- CreateIndex
CREATE INDEX "monitors_is_down_idx" ON "monitors"("is_down");

-- CreateIndex
CREATE INDEX "ping_results_monitor_id_created_at_idx" ON "ping_results"("monitor_id", "created_at");

-- CreateIndex
CREATE INDEX "ping_results_created_at_idx" ON "ping_results"("created_at");

-- CreateIndex
CREATE INDEX "incidents_monitor_id_idx" ON "incidents"("monitor_id");

-- CreateIndex
CREATE INDEX "incidents_started_at_idx" ON "incidents"("started_at");

-- AddForeignKey
ALTER TABLE "monitors" ADD CONSTRAINT "monitors_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ping_results" ADD CONSTRAINT "ping_results_monitor_id_fkey" FOREIGN KEY ("monitor_id") REFERENCES "monitors"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "incidents" ADD CONSTRAINT "incidents_monitor_id_fkey" FOREIGN KEY ("monitor_id") REFERENCES "monitors"("id") ON DELETE CASCADE ON UPDATE CASCADE;
