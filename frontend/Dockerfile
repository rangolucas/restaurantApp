FROM node:alpine AS build
WORKDIR /app
COPY . .
RUN npm install && npm run build

FROM nginx:alpine
ENV SERVER_NAME=localhost
ENV VITE_RUN_MODE=production
COPY --from=build /app/dist /usr/share/nginx/html
COPY ./.docker_resources/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80