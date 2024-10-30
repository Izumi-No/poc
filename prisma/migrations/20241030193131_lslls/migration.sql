/*
  Warnings:

  - You are about to drop the column `cameraNumber` on the `Vod` table. All the data in the column will be lost.
  - Added the required column `cameraName` to the `Vod` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Vod" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "cameraName" TEXT NOT NULL,
    "deletedAt" DATETIME,
    "hlsUrl" TEXT NOT NULL,
    "rtmpUrl" TEXT NOT NULL,
    "equipmentCode" TEXT NOT NULL
);
INSERT INTO "new_Vod" ("createdAt", "deletedAt", "equipmentCode", "hlsUrl", "id", "rtmpUrl", "updatedAt") SELECT "createdAt", "deletedAt", "equipmentCode", "hlsUrl", "id", "rtmpUrl", "updatedAt" FROM "Vod";
DROP TABLE "Vod";
ALTER TABLE "new_Vod" RENAME TO "Vod";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
