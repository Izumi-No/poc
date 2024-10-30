-- CreateTable
CREATE TABLE "Vod" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "cameraName" TEXT NOT NULL,
    "deletedAt" DATETIME,
    "hlsUrl" TEXT NOT NULL,
    "rtmpUrl" TEXT NOT NULL,
    "equipmentCode" TEXT NOT NULL
);
