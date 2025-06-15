# Use Ubuntu as base image since the services are based on Ubuntu
FROM ubuntu:22.04

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    ca-certificates \
    lsb-release \
    git \
    nginx \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Set working directory
WORKDIR /app

# Clone the repository
RUN git clone https://github.com/matthew-pest/huly.git .

# Copy configuration files
COPY .huly.nginx /etc/nginx/conf.d/default.conf
COPY .huly.secret /etc/secrets/secret

# Create nginx symlink
RUN ln -s /app/nginx.conf /etc/nginx/sites-enabled/huly.conf

# Expose the main service port
EXPOSE 80

# Set environment variables
ENV NODE_ENV=production

# Start nginx
CMD service nginx start 