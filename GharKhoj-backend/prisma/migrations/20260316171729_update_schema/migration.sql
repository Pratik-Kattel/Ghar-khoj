/*
  Warnings:

  - You are about to drop the column `tenant_id` on the `reviews` table. All the data in the column will be lost.
  - Added the required column `tenant_email` to the `reviews` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "reviews" DROP CONSTRAINT "reviews_tenant_id_fkey";

-- AlterTable
ALTER TABLE "reviews" DROP COLUMN "tenant_id",
ADD COLUMN     "tenant_email" TEXT NOT NULL;

-- AddForeignKey
ALTER TABLE "reviews" ADD CONSTRAINT "reviews_tenant_email_fkey" FOREIGN KEY ("tenant_email") REFERENCES "users"("email") ON DELETE RESTRICT ON UPDATE CASCADE;
