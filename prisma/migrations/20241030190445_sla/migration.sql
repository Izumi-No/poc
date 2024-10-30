/*
  Warnings:

  - You are about to drop the `Equipment` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the column `equipmentId` on the `Vod` table. All the data in the column will be lost.
  - Added the required column `equipmentCode` to the `Vod` table without a default value. This is not possible if the table is not empty.

*/
-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "Equipment";
PRAGMA foreign_keys=on;

-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Vod" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "cameraNumber" INTEGER NOT NULL DEFAULT 0,
    "deletedAt" DATETIME,
    "hlsUrl" TEXT NOT NULL,
    "rtmpUrl" TEXT NOT NULL,
    "equipmentCode" TEXT NOT NULL
);
INSERT INTO "new_Vod" ("cameraNumber", "createdAt", "deletedAt", "hlsUrl", "id", "rtmpUrl", "updatedAt") SELECT "cameraNumber", "createdAt", "deletedAt", "hlsUrl", "id", "rtmpUrl", "updatedAt" FROM "Vod";
DROP TABLE "Vod";
ALTER TABLE "new_Vod" RENAME TO "Vod";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
