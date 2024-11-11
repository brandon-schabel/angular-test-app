# Stage 1: Build the Angular app
FROM node:20-alpine AS build

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install

COPY . .
RUN npm run build

# Stage 2: Serve the app with NGINX
FROM nginx:1.21-alpine

# Create directory for SSL certificates
RUN mkdir -p /etc/nginx/ssl

# Copy nginx configuration to the correct location
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the build output
COPY --from=build /app/dist/my-angular-app/browser /usr/share/nginx/html

# Expose both HTTP and HTTPS ports
EXPOSE 80 443

# Update healthcheck to use http instead of https
HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost/health || exit 1

CMD ["nginx", "-g", "daemon off;"]