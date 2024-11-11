# Stage 1: Build the Angular app
FROM node:20-alpine AS build

WORKDIR /app
COPY package.json package-lock.json ./
COPY nginx.conf /etc/nginx/conf.d/default.conf
RUN npm install

# Copy all files and build the app
COPY . .
RUN npm run build
# Add this to check the build output
RUN ls -la dist/my-angular-app


# Stage 2: Serve the app with NGINX
FROM nginx:1.21-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the build output to the NGINX html directory
COPY --from=build /app/dist/my-angular-app/browser /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start NGINX server
CMD ["nginx", "-g", "daemon off;"]