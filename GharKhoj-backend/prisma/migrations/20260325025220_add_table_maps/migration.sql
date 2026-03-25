/*
  Warnings:

  - You are about to drop the `LandlordDocuments` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `LandlordRequests` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "LandlordDocuments" DROP CONSTRAINT "LandlordDocuments_requestId_fkey";

-- DropForeignKey
ALTER TABLE "LandlordRequests" DROP CONSTRAINT "LandlordRequests_userId_fkey";

-- DropTable
DROP TABLE "LandlordDocuments";

-- DropTable
DROP TABLE "LandlordRequests";

-- CreateTable
CREATE TABLE "landlord_requests" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "status" "LandlordRequestStatus" NOT NULL DEFAULT 'PENDING',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "landlord_requests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "landlord_documents" (
    "id" TEXT NOT NULL,
    "requestId" TEXT NOT NULL,
    "docName" TEXT NOT NULL,
    "docPath" TEXT NOT NULL,

    CONSTRAINT "landlord_documents_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "landlord_requests_userId_key" ON "landlord_requests"("userId");

-- AddForeignKey
ALTER TABLE "landlord_requests" ADD CONSTRAINT "landlord_requests_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "landlord_documents" ADD CONSTRAINT "landlord_documents_requestId_fkey" FOREIGN KEY ("requestId") REFERENCES "landlord_requests"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
