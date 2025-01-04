FROM tensorchord/pgvecto-rs:pg15-v0.3.0

ARG USER=patroni
ARG HOME_DIR=/home/$USER

RUN apt-get update \
	&& apt-get install --no-install-recommends patroni -y \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*

RUN adduser \
	--disabled-password \
	--uid 1000 \
	$USER

USER $USER
WORKDIR $HOME_DIR

COPY entrypoint.sh .

ENV DATA_DIR=$HOME_DIR/data

ENTRYPOINT ["bash", "entrypoint.sh"]
CMD ["--help"]
