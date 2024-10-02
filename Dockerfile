# Use Alpine Linux
FROM alpine:latest

# Install OpenJDK and other dependencies
RUN apk add --no-cache openjdk11 curl bash

# Install Leiningen
RUN curl -O https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
RUN mv lein /usr/local/bin/lein
RUN chmod a+x /usr/local/bin/lein
RUN lein

# Copy your script into the container
COPY make-jetty-server.sh /usr/local/bin/make-jetty-server.sh
RUN chmod +x /usr/local/bin/make-jetty-server.sh

# Set the working directory
WORKDIR /app

# Port to expose (3000 is the port used by your Jetty server)
EXPOSE 3000

# Command to run your script
CMD ["/usr/local/bin/make-jetty-server.sh"]

