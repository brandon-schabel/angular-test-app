# Stage 1: Build the Angular app
FROM node:20-alpine AS build

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install

COPY . .
RUN npm run build

# Stage 2: Serve the app with NGINX
FROM nginx:1.21-alpine

# Copy nginx configuration first
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the build output
COPY --from=build /app/dist/my-angular-app/browser /usr/share/nginx/html

EXPOSE 80

# Update healthcheck to use curl instead of wget
HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost/health || exit 1

CMD ["nginx", "-g", "daemon off;"]