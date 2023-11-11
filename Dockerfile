# build stage
FROM node:lts as build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# production stage
FROM nginx:stable-alpine as production-stage
COPY ./conf/nginx.conf /etc/nginx/nginx.conf
RUN mkdir -p /etc/ssl
COPY /etc/ssl/journeyplanner.io.* /etc/ssl/
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 443
CMD ["nginx", "-g", "daemon off;"]
