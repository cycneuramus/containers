FROM ghcr.io/tensorchord/vchord-postgres:pg15-v0.3.0

ARG USER=patroni
ARG HOME_DIR=/home/$USER

RUN apt-get update \
	&& apt-get install --no-install-recommends patroni -y \
	&& apt-get clean && rm -rf /var/lib/apt/lists/* \
	&& adduser --disabled-password --uid 1000 $USER

USER $USER

WORKDIR $HOME_DIR
ENV DATA_DIR=$HOME_DIR/data

COPY entrypoint.sh .

ENTRYPOINT ["bash", "entrypoint.sh"]
CMD ["--help"]
