# Kali Linux Rolling with some stuff installed
FROM kalilinux/kali-rolling:latest

LABEL maintainer="your_email@example.com"

# Set non-interactive mode for apt
ENV DEBIAN_FRONTEND noninteractive

# Apt update
COPY install.sh /tmp/
RUN chmod +x /tmp/install.sh && /tmp/install.sh

ENTRYPOINT ["tail", "-f", "/dev/null"]
