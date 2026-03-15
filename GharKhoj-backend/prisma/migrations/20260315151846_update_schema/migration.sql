/*
  Warnings:

  - You are about to drop the column `address` on the `houses` table. All the data in the column will be lost.
  - You are about to drop the column `is_approved` on the `houses` table. All the data in the column will be lost.
  - You are about to drop the column `is_featured` on the `houses` table. All the data in the column will be lost.
  - You are about to drop the column `landlord_id` on the `houses` table. All the data in the column will be lost.
  - Added the required column `landlord_email` to the `houses` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "houses" DROP CONSTRAINT "houses_landlord_id_fkey";

-- AlterTable
ALTER TABLE "houses" DROP COLUMN "address",
DROP COLUMN "is_approved",
DROP COLUMN "is_featured",
DROP COLUMN "landlord_id",
ADD COLUMN     "landlord_email" TEXT NOT NULL;

-- AddForeignKey
ALTER TABLE "houses" ADD CONSTRAINT "houses_landlord_email_fkey" FOREIGN KEY ("landlord_email") REFERENCES "users"("email") ON DELETE RESTRICT ON UPDATE CASCADE;
