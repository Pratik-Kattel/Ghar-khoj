/*
  Warnings:

  - You are about to drop the column `user_id` on the `wishlists` table. All the data in the column will be lost.
  - Added the required column `user_email` to the `wishlists` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "wishlists" DROP CONSTRAINT "wishlists_user_id_fkey";

-- AlterTable
ALTER TABLE "wishlists" DROP COLUMN "user_id",
ADD COLUMN     "user_email" TEXT NOT NULL;

-- AddForeignKey
ALTER TABLE "wishlists" ADD CONSTRAINT "wishlists_user_email_fkey" FOREIGN KEY ("user_email") REFERENCES "users"("email") ON DELETE RESTRICT ON UPDATE CASCADE;
