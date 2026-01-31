#!/bin/bash

# Add it to crontab to run every minute and log to syslog
# sudo crontab -e
# */1 * * * * /bin/bash /usr/local/bin/wg-resolve-dns.sh [DOMAIN] [WG_CLIENT_NAME] | /usr/bin/logger -t wg-resolve-dns

script_name="$(basename "${0}")"

help_and_exit() {
	echo -e "$1\n"
	echo "Usage:"
	echo "./${script_name} [DOMAIN] [WG_CLIENT_NAME]"
	exit 1
}

if [[ $# != 2 ]]; then
	help_and_exit "invalid parameters"
fi

DOMAIN=${1}
WG_CLIENT_NAME=${2}

LAST_IP_DIR="/var/lib/wg-resolve-dns"
LAST_IP_FILENAME="last_ip"
LAST_IP_PATH="$LAST_IP_DIR/$LAST_IP_FILENAME"

mkdir -p $LAST_IP_DIR

host_output=$(host -t A "$DOMAIN")
ret=$?
if [[ $ret -ne 0 ]]; then
	echo "failed to query domain: ${DOMAIN}"
	exit $ret
fi

ip=$(awk '/has address/ {print $NF; exit}' <<<"$host_output")

if [ -f "$LAST_IP_PATH" ]; then
	last_ip=$(<$LAST_IP_PATH)
	if [[ "$last_ip" == "$ip" ]]; then
		echo "IP didn't change: $DOMAIN $ip"
		exit 0
	fi
fi

echo "writting new IP $ip to $LAST_IP_PATH"
cat >"$LAST_IP_PATH" <<<"$ip"

echo "Restarting service $WG_CLIENT_NAME"
systemctl restart wg-quick@"$WG_CLIENT_NAME"
