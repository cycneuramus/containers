ARG IMG_VERSION=5.43.5-slim-trixie

FROM docker.io/perl:${IMG_VERSION} AS build

ARG DEBIAN_FRONTEND=noninteractive
ARG REPO=https://github.com/cycneuramus/diogenes
ARG BRANCH=master

RUN apt-get update && apt-get install -y --no-install-recommends \
    git make unzip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/diogenes

RUN git clone --depth 1 --branch "$BRANCH" "$REPO" . \
    && make

FROM perl:${IMG_VERSION}

ARG DEBIAN_FRONTEND=noninteractive
ARG USER=diogenes
ARG UID=1000

RUN useradd -m -u "$UID" "$USER"

WORKDIR /home/$USER/diogenes

COPY --from=build --chown=$UID:$UID /opt/diogenes .

USER $USER

CMD ["perl", "server/diogenes-server.pl", "-H", "0.0.0.0", "-P", "/data"]
