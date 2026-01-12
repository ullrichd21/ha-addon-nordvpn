#!/usr/bin/env bash
set -euo pipefail

OPTIONS="/data/options.json"

TOKEN="$(jq -r '.token // ""' "$OPTIONS")"
CONNECT="$(jq -r '.connect // true' "$OPTIONS")"
COUNTRY="$(jq -r '.country // ""' "$OPTIONS")"
CITY="$(jq -r '.city // ""' "$OPTIONS")"
SERVER="$(jq -r '.server // ""' "$OPTIONS")"
AUTOCONNECT="$(jq -r '.autoconnect // true' "$OPTIONS")"
KILLSWITCH="$(jq -r '.killswitch // true' "$OPTIONS")"

if [[ -z "$TOKEN" ]]; then
	echo "ERROR: NordVPN token is empty. Set it in the add-on configuration."
	exit 1
fi

echo "Starting nordvpnd..."
if command -v nordvpnd >/dev/null 2>&1; then
	nordvpnd &
elif [[ -x /usr/sbin/nordvpnd ]]; then
	/usr/sbin/nordvpnd &
else
	echo "ERROR: nordvpnd not found."
	exit 1
fi

# Give daemon a moment to spin up
sleep 2

echo "Logging in..."
# Token login
nordvpn login --token "$TOKEN" || true

# Apply settings (ignore failures if unsupported)
nordvpn set technology nordlynx || true
if [[ "$AUTOCONNECT" == "true" ]]; then nordvpn set autoconnect on || true; else nordvpn set autoconnect off || true; fi
if [[ "$KILLSWITCH" == "true" ]]; then nordvpn set killswitch on || true; else nordvpn set killswitch off || true; fi

if [[ "$CONNECT" == "true" ]]; then
	echo "Connecting..."
	if [[ -n "$SERVER" ]]; then
		nordvpn connect "$SERVER"
	elif [[ -n "$CITY" ]]; then
		nordvpn connect "$CITY"
	elif [[ -n "$COUNTRY" ]]; then
		nordvpn connect "$COUNTRY"
	else
		nordvpn connect
	fi
else
	echo "CONNECT=false; not connecting."
fi

echo "NordVPN add-on is running."
tail -f /dev/null
