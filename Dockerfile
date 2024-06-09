# Use the official Ubuntu 22.04 LTS image as the base image
FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive

# Set the working directory in the container
WORKDIR /app


# Install essential packages
RUN apt-get -y update && \
    apt-get install -y \
    python3 \
    python3-pip \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements.txt first to make use of caching
COPY lichess-bot/requirements.txt /app/lichess-bot/requirements.txt

# Install the Python packages specified in requirements.txt
RUN pip3 install --no-cache-dir -r /app/lichess-bot/requirements.txt

## Leela chess stuff
RUN apt-get update && apt-get install -y \
    build-essential \
    libopenblas-dev \
    ninja-build \
    libgtest-dev \
    git
#     clang-6.0 \
#     libstdc++-8-dev

COPY lc0 lc0
WORKDIR /app/lc0
RUN git clone https://github.com/xianyi/OpenBLAS.git
WORKDIR /app/lc0/OpenBLAS
RUN make TARGET=ARMV8
RUN pip3 install --no-cache-dir meson ninja
WORKDIR /app/lc0
# RUN CC=clang-6.0 CXX=clang++-6.0 ./build.sh -Ddefault_library=static
# COPY lichess-bot /app/lichess-bot
# WORKDIR lichess-bot
