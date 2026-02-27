/*
  Warnings:

  - The `status` column on the `bookings` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - You are about to drop the column `payment_status` on the `payments` table. All the data in the column will be lost.

*/
-- CreateEnum
CREATE TYPE "BookingStatus" AS ENUM ('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED');

-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('PENDING', 'SUCCESS', 'FAILED', 'REFUNDED');

-- CreateEnum
CREATE TYPE "LandlordRequestStatus" AS ENUM ('PENDING', 'APPROVED', 'REJECTED');

-- AlterTable
ALTER TABLE "bookings" DROP COLUMN "status",
ADD COLUMN     "status" "BookingStatus" NOT NULL DEFAULT 'PENDING';

-- AlterTable
ALTER TABLE "payments" DROP COLUMN "payment_status",
ADD COLUMN     "paymentStatus" "PaymentStatus" NOT NULL DEFAULT 'PENDING';

-- AlterTable
ALTER TABLE "users" ALTER COLUMN "role" SET DEFAULT 'TENANT';

-- CreateTable
CREATE TABLE "LandlordRequests" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "status" "LandlordRequestStatus" NOT NULL DEFAULT 'PENDING',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "LandlordRequests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LandlordDocuments" (
    "id" TEXT NOT NULL,
    "requestId" TEXT NOT NULL,
    "docName" TEXT NOT NULL,
    "docPath" TEXT NOT NULL,

    CONSTRAINT "LandlordDocuments_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "LandlordRequests_userId_key" ON "LandlordRequests"("userId");

-- AddForeignKey
ALTER TABLE "LandlordRequests" ADD CONSTRAINT "LandlordRequests_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LandlordDocuments" ADD CONSTRAINT "LandlordDocuments_requestId_fkey" FOREIGN KEY ("requestId") REFERENCES "LandlordRequests"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
