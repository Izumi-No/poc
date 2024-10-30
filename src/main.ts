import express from "express";
import { PrismaClient } from "@prisma/client";
import { z } from "zod";
import { env } from "./env.js";

const prisma = new PrismaClient();

const AddVodSchema = z.object({
    equipmentCode: z.string(),
    cameraName: z.string(),
});

const app = express();

app.use(express.json());

const { RTMP_URL, HLS_URL, PORT } = env;

const vodRouter = express.Router();

vodRouter.post("/", async (req, res) => {
    try {
        const {
            success: isValid,
            error: validationError,
            data
        } = AddVodSchema.safeParse(req.body);

        if (!isValid) {
            res.status(400).json({
                success: false,
                error: validationError.format()
            });
            return;
        }

        const vod = await prisma.vod.create({
            data: {
                equipmentCode: data.equipmentCode,
                rtmpUrl: `${RTMP_URL}/${data.equipmentCode}_${data.cameraName}`,
                hlsUrl: `${HLS_URL}/${data.equipmentCode}_${data.cameraName}/index.m3u8`,
                cameraName: data.cameraName
            },
        });
        res.status(200).json({
            success: true,
            data: vod
        });
    } catch (error) {
        console.error("Error creating VOD:", error);
        res.status(500).json({
            success: false,
            error: "An error occurred while creating the VOD"
        });
    }
});

app.get("/api/vod", async (req, res) => {
    try {
        const vod = await prisma.vod.findMany();
        res.status(200).json({
            success: true,
            data: vod
        });
    } catch (error) {
        console.error("Error fetching VODs:", error);
        res.status(500).json({
            success: false,
            error: "An error occurred while fetching VODs"
        });
    }
});

app.get("/api/vod/:equipmentCode", async (req, res) => {
    try {
        const vod = await prisma.vod.findMany({
            where: {
                equipmentCode: req.params.equipmentCode
            }
        });
        
        if (vod.length === 0) {
            res.status(404).json({
                success: false,
                error: "No VODs found for the given equipment code"
            });
            return;
        }
        
        res.status(200).json({
            success: true,
            data: vod
        });
    } catch (error) {
        console.error("Error fetching VOD by equipment code:", error);
        res.status(500).json({
            success: false,
            error: "An error occurred while fetching VOD by equipment code"
        });
    }
});

app.use("/api/vod", vodRouter);

// Global error handler
app.use((err: Error, req: express.Request, res: express.Response, next: express.NextFunction) => {
    console.error("Unhandled error:", err);
    res.status(500).json({
        success: false,
        error: "An unexpected error occurred"
    });
});

const startServer = async () => {
    try {
        await prisma.$connect();
        app.listen(PORT, () => {
            console.log("Server started on port " + PORT);
        });
    } catch (error) {
        console.error("Failed to start server:", error);
        process.exit(1);
    }
};

startServer().catch((error) => {
    console.error("Unhandled error during server startup:", error);
    process.exit(1);
});

// Graceful shutdown
process.on('SIGINT', async () => {
    try {
        await prisma.$disconnect();
        console.log('Disconnected from database');
        process.exit(0);
    } catch (error) {
        console.error('Error during graceful shutdown:', error);
        process.exit(1);
    }
});