FROM ubuntu:latest

# Install required packages
RUN apt-get update && \
    apt-get install -y mysql-client mailutils

# Copy the bash script to the container
COPY bash.sh /usr/local/bin/

# Set the script as executable
RUN chmod +x /usr/local/bin/bash.sh

# Set the container working directory
WORKDIR /usr/local/bin

# Run the command on container startup
CMD while true; do ./bash.sh && sleep 30; done
