#!/usr/bin/env bash

if [ ! -d "/var/log/wattaged" ]; then
    mkdir -p /var/log/wattaged
fi
APC="/usr/sbin/apcaccess"

test_is_num(){
    re='^[0-9]+([.][0-9]+)?$'
    if ! [[ "$1" =~ $re ]] ; then
        echo "error: Not a number" >&2; exit 1
    fi
}
load_pct=$($APC -p LOADPCT | cut -d' ' -f 1)
nom_pwr=$($APC -p NOMPOWER | cut -d' ' -f 1)

# Don't print anything if we couldn't get hold of the statistics
test_is_num "$load_pct"
test_is_num "$nom_pwr"

echo -ne "$(date -u +'%Y-%m-%dT%H:%M:%S%Z')\t"
bc <<< "scale=1; ${load_pct}*${nom_pwr}/100.0"
