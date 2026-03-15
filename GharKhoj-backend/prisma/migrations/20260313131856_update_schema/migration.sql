/*
  Warnings:

  - A unique constraint covering the columns `[email]` on the table `user_locations` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "user_locations_email_key" ON "user_locations"("email");
