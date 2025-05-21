# Use official Debian base
FROM nginx:alpine

# Install Apache2
RUN apt-get update && \
    apt-get install -y nginx:alpine && \
    apt-get clean && \

# Expose port 80
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2ctl", "-D", "FOREGROUND"]
