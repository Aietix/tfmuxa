# Stage 1: Build stage using Ubuntu image
FROM alpine:3 AS builder

# Install essential tools
RUN apk add --no-cache curl tar unzip wget

# Get target OS and architecture
ARG TARGETOS TARGETARCH

# Set versions
ARG TFLINT_VERSION=0.47.0
ARG TFSEC_VERSION=1.28.1
ARG TERRASCAN_VERSION=1.18.1

# Set working directory
WORKDIR /tmp

# Install TFLint
RUN wget -O tflint.zip https://github.com/terraform-linters/tflint/releases/download/v"${TFLINT_VERSION}"/tflint_"${TARGETOS}"_"${TARGETARCH}".zip \
    && unzip tflint.zip -d /usr/local/bin \
    && rm tflint.zip

# Install TFSec
RUN wget -O /usr/local/bin/tfsec https://github.com/aquasecurity/tfsec/releases/download/v"${TFSEC_VERSION}"/tfsec-"${TARGETOS}"-"${TARGETARCH}" \
    && chmod +x /usr/local/bin/tfsec

# Install Terrascan
# Convert the first letter of ${TARGETOS} to uppercase
RUN wget -O terrascan.tar.gz https://github.com/tenable/terrascan/releases/download/v"${TERRASCAN_VERSION}"/terrascan_"${TERRASCAN_VERSION}"_"$(echo ${TARGETOS} | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')"_"${TARGETARCH}".tar.gz \
    && tar -xf terrascan.tar.gz terrascan && rm terrascan.tar.gz \
    && install terrascan /usr/local/bin && rm terrascan


# Stage 2: Main image based on Ubuntu
FROM alpine:3 AS main

# Install essential tools
RUN apk add --no-cache git

# Set working directory
WORKDIR /workspace

# Copy binaries from builder stage
COPY --from=builder /usr/local/bin/tflint /usr/local/bin/tflint
COPY --from=builder /usr/local/bin/tfsec /usr/local/bin/tfsec
COPY --from=builder /usr/local/bin/terrascan /usr/local/bin/terrascan

# Copy entrypoint script
COPY entrypoint.sh /opt/entrypoint.sh

# Set execute permissions for the entrypoint script
RUN chmod +x /opt/entrypoint.sh

# Set the entrypoint script to run when the container starts
ENTRYPOINT [ "/opt/entrypoint.sh" ]
