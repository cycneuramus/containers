ARG python_version=3.13
ARG debian_version=trixie

FROM python:${python_version}-slim-${debian_version}

ARG signalbot_version=0.20.0
ARG supercronic_version=v0.2.34
ARG supercronic_sha=e8631edc1775000d119b70fd40339a7238eece14

ARG USER=sigurd
ARG HOME_DIR=/home/$USER
ARG BOT_DIR=$HOME_DIR/bot

ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/${supercronic_version}/supercronic-linux-amd64 \
	SUPERCRONIC_SHA1SUM=${supercronic_sha} \
	SUPERCRONIC=supercronic-linux-amd64

RUN apt-get update && apt-get install -y \
	curl \
	ffmpeg \
	libavcodec-extra

RUN curl -fsSLO "$SUPERCRONIC_URL" \
	&& echo "${SUPERCRONIC_SHA1SUM} ${SUPERCRONIC}" | sha1sum -c - \
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
	signalbot==${signalbot_version} \
	tekore \
	tinydb

WORKDIR $BOT_DIR

ENTRYPOINT ["sh", "entrypoint.sh"]
