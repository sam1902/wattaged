#!/usr/bin/env bash

if [ ! -d "/var/log/wattaged" ]; then
    mkdir -p /var/log/wattaged
fi
APC="/usr/sbin/apcaccess"
echo -ne "$(date -u +'%Y-%m-%dT%H:%M:%S%Z')\t"
bc <<< "scale=1; $($APC -p LOADPCT | cut -d' ' -f 1)*$($APC -p NOMPOWER | cut -d' ' -f 1)/100.0"


