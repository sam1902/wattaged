#!/usr/bin/env bash

if ! command -v apcaccess >/dev/null 2>&1; then
    echo "You need to have apcupsd installed !" >&2
    echo "If you know another way to harvest your current wattage, you can modify the wattage_apcupsd.sh to suit your setup" >&2
    exit 1
fi

if ! command -v logrotate >/dev/null 2>&1; then
    echo "You need to have logrotate installed !" >&2
    exit 1
fi

if ! command -v wget >/dev/null 2>&1; then
    echo "You need to have wget installed !" >&2
    exit 1
fi

echo "This script will run some commands as sudo and ask for your password."
echo "Make sure to read the script to make sure nothing nasty is going on. Here is its url:"
echo "https://raw.githubusercontent.com/sam1902/wattaged/HEAD/install.sh"
sleep 5

sudo echo "Thank you for your cooperation"

WATTAGE_APCUPSD_URL="https://raw.githubusercontent.com/sam1902/wattaged/HEAD/wattaged/wattage_apcupsd.sh"
WATTAGE_LOGROTATE_URL="https://raw.githubusercontent.com/sam1902/wattaged/HEAD/wattaged/wattaged_logrotate.cfg"

set -e
if [ ! -d /opt/wattaged ]; then
    sudo mkdir -p /opt/wattaged
fi
if [ ! -f /opt/wattaged/wattage_apcupsd.sh ]; then
    echo "Installing the daemon script to /opt/wattaged"
    if [ -f wattaged/wattage_apcupsd.sh  ]; then
        sudo cp wattaged/wattage_apcupsd.sh /opt/wattaged
    else
        sudo wget $WATTAGE_APCUPSD_URL -O /opt/wattaged/wattage_apcupsd.sh
    fi
    sudo chown -R root:root /opt/wattaged
    sudo chmod 744 /opt/wattaged/wattage_apcupsd.sh
fi

trap 'rm -f "$TMPFILE"' EXIT
TMPFILE=$(mktemp) || exit 1

sudo crontab -l > $TMPFILE
if ! grep -c "wattaged" $TMPFILE; then
    echo "Adding the cron task"
    echo "*/5 * * * * /opt/wattaged/wattage_apcupsd.sh 2>/dev/null >> /var/log/wattaged/watts.log" >> $TMPFILE
    sudo crontab $TMPFILE
fi
rm $TMPFILE

if [ ! -f /etc/logrotate.d/wattaged ]; then
    echo "Installing the logrotate config file to /etc/logrotate"
    if [ -f wattaged/wattaged_logrotate.cfg ]; then
        sudo cp wattaged/wattaged_logrotate.cfg /etc/logrotate.d/wattaged
    else
        sudo wget $WATTAGE_LOGROTATE_URL -O /etc/logrotate.d/wattaged/wattaged_logrotate.cfg
    fi
    sudo chmod 744 /etc/logrotate.d/wattaged
    sudo chown root:root /etc/logrotate.d/wattaged
fi

echo "Done"
