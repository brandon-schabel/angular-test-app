# Stage 1: Build the Angular app
FROM node:20-alpine AS build

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install

# Copy all files and build the app
COPY . .
RUN npm run build --prod

# Stage 2: Serve the app with NGINX
FROM nginx:1.21-alpine

# Copy the build output to the NGINX html directory
COPY --from=build /app/dist/my-angular-app /usr/share/nginx/html

# Copy custom NGINX configuration if needed
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start NGINX server
CMD ["nginx", "-g", "daemon off;"]

