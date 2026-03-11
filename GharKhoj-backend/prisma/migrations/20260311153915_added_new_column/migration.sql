/*
  Warnings:

  - Added the required column `email` to the `otp_logs` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "otp_logs" ADD COLUMN     "email" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "users" ALTER COLUMN "updated_at" DROP NOT NULL;
