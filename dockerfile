# Stage 1: Build React app
FROM node:18 AS builder
WORKDIR /app

# Install git
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Clone GitHub repo
RUN git clone -b main https://github.com/mkr3295/App-Kubernetes.git .

# Install dependencies and build
RUN npm ci
ENV NODE_ENV=production
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]