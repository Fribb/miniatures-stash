# Build the Angular Frontend
FROM node:14-alpine AS frontend-build

WORKDIR /app

COPY ./frontend-angular /app/.

RUN npm install
RUN node_modules/.bin/ng build --configuration production

# Build the NodeJS ExpressJS Backend
FROM node:14-alpine AS server-build

WORKDIR /app
COPY ./backend /app/.
COPY --from=frontend-build /app/dist/frontend-angular /app/public

RUN npm install --production

# Build image
FROM lsiobase/alpine:3.16

ENV PUID="1000"
ENV PGID="1000"

COPY root /

WORKDIR /app

RUN apk add --no-cache nodejs

COPY --from=server-build /app ./

ENTRYPOINT ["/init"]
