# Step 1: Build frontend
FROM node:18-alpine AS frontend
WORKDIR /app
COPY package*.json ./
COPY frontend/package*.json frontend/
RUN npm install --prefix frontend
COPY frontend ./frontend
RUN npm run build --prefix frontend

# Step 2: Backend + final image
FROM node:18-alpine
WORKDIR /app

# Copy backend package.json and install backend dependencies
COPY package*.json ./
COPY backend/package*.json backend/
RUN npm install

# Copy backend source
COPY backend ./backend

# Copy frontend build from step 1 to backend/public (so Express can serve it)
COPY --from=frontend /app/frontend/build ./backend/public

# Env vars
ENV NODE_ENV=production
ENV PORT=5000

EXPOSE 5000

CMD ["node", "backend/server.js"]
