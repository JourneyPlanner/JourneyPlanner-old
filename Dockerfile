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
COPY JourneyPlanner/conf/microsoft-identity-association.json /var/www/journeyplanner.io/html/.well-known/microsoft-identity-association.json
COPY JourneyPlanner/templates/src/index.html /var/www/journeyplanner.io/html/templates/email/confirmation.html
EXPOSE 443
CMD ["nginx", "-g", "daemon off;"]
