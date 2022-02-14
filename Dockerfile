FROM node:16.14.0-alpine AS dependencies

WORKDIR /home/node

COPY package*.json yarn.lock ./
RUN yarn install --frozen-lockfile

FROM node:16.14.0-alpine AS builder

WORKDIR /home/node

COPY --from=dependencies /home/node/node_modules ./node_modules
COPY . .

RUN yarn build

FROM node:16.14.0-alpine AS runner

ENV NODE_ENV=production

RUN adduser -D app
USER app
WORKDIR /home/app

COPY --chown=app --from=builder /home/node/next.config.js ./
COPY --chown=app --from=builder /home/node/public ./public
COPY --chown=app --from=builder /home/node/.next/standalone ./
COPY --chown=app --from=builder /home/node/.next/static ./.next/static

EXPOSE 3000

CMD ["node", "server.js"]
