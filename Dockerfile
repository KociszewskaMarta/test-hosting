# Build stage
FROM node:18-alpine AS builder

WORKDIR /app

# Accept build arguments
ARG NEXT_PUBLIC_SUPABASE_URL
ARG NEXT_PUBLIC_SUPABASE_ANON_KEY

# Set environment variables for build
ENV NEXT_PUBLIC_SUPABASE_URL=${NEXT_PUBLIC_SUPABASE_URL}
ENV NEXT_PUBLIC_SUPABASE_ANON_KEY=${NEXT_PUBLIC_SUPABASE_ANON_KEY}

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Production stage
FROM node:18-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production

# Copy public assets from builder
COPY --from=builder /app/public ./public

# Copy package files
COPY --from=builder /app/package*.json ./

# Copy built application
COPY --from=builder /app/.next/standalone ./

# Copy .next folder for static files
COPY --from=builder /app/.next/static ./.next/static

# Install production dependencies only
RUN npm ci --only=production

EXPOSE 3000

CMD ["node", "server.js"]
