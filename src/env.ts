import { z } from "zod"

const envSchema = z.object({
    RTMP_URL: z.string().url(),
    HLS_URL: z.string().url(),
    PORT: z.string().refine(v => parseInt(v) > 0, { message: "PORT must be a number greater than 0" }).default("3000"),
})


try {
    envSchema.parse(process.env)
} catch (error) {
    console.log(error)
    process.exit(1)
}

export const env =  envSchema.parse(process.env)