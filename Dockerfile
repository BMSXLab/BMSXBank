# Docker deployment example
# build like:
# docker build . -t bmsxbank:1 -t bmsxbank:latest
# run like:
# docker run --name bmsxbank -p9000:80 -d bmsxbank:latest
# test like:
# http://localhost:9000
#
FROM node:18.13-alpine AS build
WORKDIR /usr/src/app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
ENV NODE_OPTIONS=--openssl-legacy-provider
RUN npm run build

FROM nginx:1.23-alpine
COPY --from=build /usr/src/app/dist/BMSXBank /usr/share/nginx/html
COPY nginx-docker-proxy.conf /etc/nginx/conf.d/default.conf

# if service worker is a problem, add ?ngsw-bypass=1

EXPOSE 80
