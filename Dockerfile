# build stage
FROM node:lts as build-stage
WORKDIR /app
COPY JourneyPlanner/package*.json ./
RUN npm install
COPY JourneyPlanner .
RUN npm run build

# production stage
FROM nginx:stable-alpine as production-stage
COPY authenticated_origin_pull_ca.pem /etc/nginx/certs/
COPY journeyplanner.io.* /etc/nginx/certs/
COPY JourneyPlanner/conf/nginx.conf /etc/nginx/nginx.conf
COPY --from=build-stage /app/dist /var/www/journeyplanner.io/html
EXPOSE 443
CMD ["nginx", "-g", "daemon off;"]
