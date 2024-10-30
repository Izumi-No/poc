/*
  Warnings:

  - You are about to drop the `VOD` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "VOD";
PRAGMA foreign_keys=on;

-- CreateTable
CREATE TABLE "Vod" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "cameraNumber" INTEGER NOT NULL DEFAULT 0,
    "deletedAt" DATETIME,
    "hlsUrl" TEXT NOT NULL,
    "rtmpUrl" TEXT NOT NULL,
    "equipmentId" TEXT NOT NULL,
    CONSTRAINT "Vod_equipmentId_fkey" FOREIGN KEY ("equipmentId") REFERENCES "Equipment" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Equipment" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "equipmentCode" TEXT NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "deletedAt" DATETIME
);
INSERT INTO "new_Equipment" ("createdAt", "deletedAt", "equipmentCode", "id", "updatedAt") SELECT "createdAt", "deletedAt", "equipmentCode", "id", "updatedAt" FROM "Equipment";
DROP TABLE "Equipment";
ALTER TABLE "new_Equipment" RENAME TO "Equipment";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
