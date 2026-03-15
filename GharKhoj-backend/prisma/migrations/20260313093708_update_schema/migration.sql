/*
  Warnings:

  - The primary key for the `user_locations` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `user_id` on the `user_locations` table. All the data in the column will be lost.
  - The required column `Location_id` was added to the `user_locations` table with a prisma-level default value. This is not possible if the table is not empty. Please add this column as optional, then populate it before making it required.

*/
-- DropForeignKey
ALTER TABLE "user_locations" DROP CONSTRAINT "user_locations_user_id_fkey";

-- AlterTable
ALTER TABLE "user_locations" DROP CONSTRAINT "user_locations_pkey",
DROP COLUMN "user_id",
ADD COLUMN     "Location_id" TEXT NOT NULL,
ADD CONSTRAINT "user_locations_pkey" PRIMARY KEY ("Location_id");
