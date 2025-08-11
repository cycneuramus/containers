#!/bin/sh -e

case $1 in
	bot)
		if [ -n "$SIGNAL_SERVICE" ]; then
			echo "Waiting for signal-cli-rest-api endpoint..."
			until curl --silent --head http://"$SIGNAL_SERVICE" > /dev/null; do
				sleep 1
			done
			echo "Found signal-cli-rest-api endpoint"
		fi

		exec python sigurd.py
		;;
	cron)
		exec /usr/local/bin/supercronic -passthrough-logs tasks/cron
		;;
esac
