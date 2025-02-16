ARG VERSION=latest
FROM nginx:$VERSION

# Determine the package manager and install necessary utilities
RUN if [ -f /etc/alpine-release ]; then \
        apk --no-cache add iproute2 bash curl; \
    else \
        apt-get update && apt-get install -y iproute2 bash curl && rm -rf /var/lib/apt/lists/*; \
    fi

# Create a script to dynamically generate the HTML file
RUN echo '#!/bin/bash' > /usr/local/bin/start.sh && \
    echo 'echo "<!DOCTYPE html>" > /usr/share/nginx/html/index.html' >> /usr/local/bin/start.sh && \
    echo 'echo "<html><head><title>Host Info</title></head>" >> /usr/share/nginx/html/index.html' >> /usr/local/bin/start.sh && \
    echo 'echo "<body style=\"background-color:darkred; color:white; text-align:center; font-size:24px;\">" >> /usr/share/nginx/html/index.html' >> /usr/local/bin/start.sh && \
    echo 'echo "<h1>Hostname: $(hostname)</h1>" >> /usr/share/nginx/html/index.html' >> /usr/local/bin/start.sh && \
    echo 'echo "<h2>Host IP: $(hostname -I | awk \"{print \$1}\")</h2>" >> /usr/share/nginx/html/index.html' >> /usr/local/bin/start.sh && \
    echo 'echo "</body></html>" >> /usr/share/nginx/html/index.html' >> /usr/local/bin/start.sh && \
    chmod +x /usr/local/bin/start.sh

# Expose port 80
EXPOSE 80

# Run the script before starting nginx
CMD ["/bin/bash", "-c", "/usr/local/bin/start.sh && nginx -g 'daemon off;'"]

#    echo 'echo "<body style=\"background-color:cornflowerblue; color:white; text-align:center; font-size:24px;\">" >> /usr/share/nginx/html/index.html' >> /usr/local/bin/start.sh && \
#docker build -t justamitsaha/show-host-info:v1 .
#docker run --rm -p 8080:80 justamitsaha/show-host-info:v1

#    echo 'echo "<body style=\"background-color:darkred; color:white; text-align:center; font-size:24px;\">" >> /usr/share/nginx/html/index.html' >> /usr/local/bin/start.sh && \
#docker build -t justamitsaha/show-host-info:v2 .
#docker run --rm -p 8080:80 justamitsaha/show-host-info:v2
