-- CreateTable
CREATE TABLE "Equipment" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "equipmentCode" TEXT NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "deletedAt" DATETIME NOT NULL
);

-- CreateTable
CREATE TABLE "VOD" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "cameraNumber" INTEGER NOT NULL DEFAULT 0,
    "deletedAt" DATETIME NOT NULL,
    "hlsUrl" TEXT NOT NULL,
    "rtmpUrl" TEXT NOT NULL,
    "equipmentId" TEXT NOT NULL,
    CONSTRAINT "VOD_equipmentId_fkey" FOREIGN KEY ("equipmentId") REFERENCES "Equipment" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
