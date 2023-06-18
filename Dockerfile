# Stage 1: Build stage using Ubuntu image
FROM ubuntu:latest AS builder

# Install necessary dependencies
RUN apt-get update && apt-get install -y curl tar jq unzip

# Install TFLint
RUN curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# Install TFSec
RUN curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash

# Install Terrascan
RUN curl -L "$(curl -s https://api.github.com/repos/tenable/terrascan/releases/latest | jq -r '.assets[] | select(.name | test("_Linux_x86_64.tar.gz")) | .browser_download_url')" > terrascan.tar.gz \
    && tar -xf terrascan.tar.gz terrascan \
    && rm terrascan.tar.gz \
    && install terrascan /usr/local/bin \
    && rm terrascan \
    && rm -rf /var/lib/apt/lists/*


# Stage 2: Main image based on Ubuntu
FROM ubuntu:latest

# Install git
RUN apt-get update && apt-get install -y git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspace

# Copy binaries from builder stage
COPY --from=builder /usr/local/bin/tflint /usr/local/bin/tflint
COPY --from=builder /usr/local/bin/tfsec /usr/local/bin/tfsec
COPY --from=builder /usr/local/bin/terrascan /usr/local/bin/terrascan

# Copy entrypoint script
COPY entrypoint.sh /opt/entrypoint.sh
COPY start.sh /opt/start.sh

# Create a symlink to start.sh as 'start'
RUN ln -s /opt/start.sh /usr/local/bin/start

# Set execute permissions for the entrypoint script
RUN chmod +x /opt/entrypoint.sh
RUN chmod +x /opt/start.sh 
    
# Set the entrypoint script to run when the container starts
ENTRYPOINT [ "/opt/entrypoint.sh" ]