import express from "express";

import { PrismaClient } from "@prisma/client";
import { z } from "zod";

const prisma = new PrismaClient({
    log: ["query"],
});

const AddVodSchema = z.object({
    equipmentCode: z.string(),
    cameraName: z.string(),
});

const app = express();

app.use(express.json());

const RTMP_SERVER_URL = "rtmp://localhost:1935/live";
const HLS_SERVER_URL = "http://localhost:80/hls";

const vodRouter = express.Router();


vodRouter.post("/", async (req, res) => {
    const {
        success: isValid,
        error: validationError,
        data
    } = AddVodSchema.safeParse(req.body);


    if (!isValid) {
        res.status(400).json({
            success: false,
            error: validationError
        });
        return;
    }


    const vod = await prisma.vod.create({
        data: {
            equipmentCode: data.equipmentCode,
            rtmpUrl: `${RTMP_SERVER_URL}/${data.equipmentCode}_${data.cameraName}`,
            hlsUrl: `${HLS_SERVER_URL}/${data.equipmentCode}_${data.cameraName}/index.m3u8`,
            cameraName: data.cameraName
        },
    });
    res.status(200).json({
        success: true,
        data: vod
    }) 
})



app.use("/api/vod", vodRouter);

app.listen(3000, () => {
    console.log("Server started on port 3000");
})


