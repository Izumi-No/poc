# Stage 1: Build
FROM node:21.6.1-alpine AS builder

WORKDIR /app

# Copy only necessary files for installation and build
COPY package.json yarn.lock ./
COPY ./src ./src
COPY ./tsconfig.json ./
COPY ./prisma ./prisma

# Set NODE_ENV to production

# Install dependencies and generate Prisma files
RUN yarn
RUN yarn prisma generate

# Build the application
RUN yarn build

# Stage 2: Production
FROM node:21.6.1-alpine AS runner

ENV NODE_ENV=production

WORKDIR /app

# Copy the built application and dependencies from the builder stage
COPY --from=builder /app/dist /app/dist
COPY --from=builder /app/node_modules /app/node_modules
COPY --from=builder /app/package.json ./
COPY --from=builder /app/yarn.lock ./
COPY --from=builder /app/prisma ./prisma
EXPOSE 3000

RUN npm install pm2 -g

RUN yarn prisma db push
RUN yarn prisma generate

# Start the application
CMD ["pm2-runtime", "dist/main.js"]
