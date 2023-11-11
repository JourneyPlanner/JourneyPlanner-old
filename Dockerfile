# build stage
FROM node:lts as build-stage
WORKDIR /app
COPY JourneyPlanner/package*.json ./
RUN npm install
COPY JourneyPlanner .
RUN npm run build

# production stage
FROM nginx:stable-alpine as production-stage
COPY journeyplanner.io.* /etc/ssl/
COPY JourneyPlanner/conf/nginx.conf /etc/nginx/nginx.conf
COPY --from=build-stage /app/dist /var/www/journeyplanner.io/html
EXPOSE 443
CMD ["nginx", "-g", "daemon off;"]
