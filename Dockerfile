FROM node:22-alpine

WORKDIR /app

RUN apk add --no-cache wget

COPY package*.json ./

RUN npm ci --omit=dev

COPY . .

# Run application as non-root user
USER node

EXPOSE 3000

CMD ["node", "server.js"]