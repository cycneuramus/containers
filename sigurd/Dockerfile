FROM python:3.13-slim-bookworm

ARG USER=sigurd
ARG HOME_DIR=/home/$USER
ARG BOT_DIR=$HOME_DIR/bot

ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.2.33/supercronic-linux-amd64 \
	SUPERCRONIC_SHA1SUM=71b0d58cc53f6bd72cf2f293e09e294b79c666d8 \
	SUPERCRONIC=supercronic-linux-amd64

RUN apt-get update && apt-get install -y \
	curl \
	ffmpeg \
	libavcodec-extra

RUN curl -fsSLO "$SUPERCRONIC_URL" \
	&& echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
	&& chmod +x "$SUPERCRONIC" \
	&& mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
	&& ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic

RUN adduser \
	--disabled-password \
	--uid 1000 \
	$USER

USER $USER

RUN mkdir -p $BOT_DIR
ENV PYTHONPATH=$BOT_DIR

RUN pip install --no-cache-dir \
    audioop-lts \
	lyricsgenius \
	pydub \
	signalbot==0.17.0 \
	tekore \
	tinydb

WORKDIR $BOT_DIR

ENTRYPOINT ["sh", "entrypoint.sh"]
