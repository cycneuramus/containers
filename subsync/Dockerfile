# Builder stage
FROM python:3.8-slim-buster AS builder

WORKDIR /app

ARG DEBIAN_FRONTEND=noninteractive
ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG CRYPTOGRAPHY_DONT_BUILD_RUST=1

RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"

RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    gcc \
    g++ \
    build-essential \
    libssl-dev \
    libffi-dev \
    git \
    swig \
    libpulse-dev \
    libasound2-dev \
    libsphinxbase3 \
    libsphinxbase-dev \
    libpocketsphinx-dev \
    libavdevice-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN python -m pip install --no-cache-dir --upgrade pip \
    && git clone https://github.com/sc0ty/subsync.git \
    && cd subsync \
	&& cp subsync/config.py.template subsync/config.py

RUN pip install --no-cache-dir --no-binary :all: "cryptography<3.5" \
    && pip install --no-cache-dir -r subsync/requirements.txt \
    && pip install --no-cache-dir pyinstaller \
    && pip install --no-cache-dir ./subsync

# Handle PyInstaller bootloaders for ARM (if applicable)
RUN if [ "$TARGETPLATFORM" = "linux/arm/v7" ]; then \
    git clone https://github.com/pyinstaller/pyinstaller.git && \
    cd pyinstaller/bootloader && \
    python ./waf distclean all && \
    cp -r PyInstaller/bootloader/Linux-32bit-arm /usr/local/lib/python3.8/site-packages/PyInstaller/bootloader; \
fi

WORKDIR /app/subsync
RUN pyinstaller --onefile bin/subsync

# Final stage
FROM python:3.8-slim-buster

ARG USER=subsync
RUN adduser --disabled-password --uid 1000 $USER

COPY --from=builder /app/subsync/dist/subsync /usr/bin/subsync

# Install runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libdrm-dev \
    libxcb1-dev \
    libgl-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

USER $USER

ENTRYPOINT ["subsync", "--cli"]
