# Dockerfile for custom Kong image with Kong Manager
FROM kong:latest

USER root

# Install curl for healthchecks
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Copy declarative configuration
COPY kong.yml /usr/local/kong/declarative/kong.yml

USER kong

# Start Kong normally (no custom consumer creation in startup)
CMD ["kong", "docker-start"]
