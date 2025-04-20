FROM squidfunk/mkdocs-material:latest as BUILDER
WORKDIR /app

# Copy and install Python dependencies
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy MkDocs config and documentation
COPY mkdocs.yml /app/mkdocs.yml
COPY docs /app/docs

# Build the MkDocs static site
RUN ["mkdocs", "build"]

# Use a lightweight web server to serve the built site
FROM nginx:stable-alpine3.17-slim

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built documentation from builder stage
COPY --from=BUILDER /app/site /var/www/documentation

# Healthcheck and expose port
HEALTHCHECK CMD curl --fail http://localhost:80 || exit 1"
EXPOSE 80