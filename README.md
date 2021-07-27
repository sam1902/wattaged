# wattaged

Wattage Daemon is a utility that logs the consummed electricity and allows you to quickly compute the consummed kWh

## Getting started

To install the CLI, run the following:
```sh
pip3 install -U wattaged
wattage --help

# Install the daemon to /opt/wattaged
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/sam1902/wattaged/HEAD/install.sh)"
```

The install script (separate from pip3 install) does a lot of things:
 - It moves the `wattage_apcupsd.sh` script to `/opt/wattaged`
 - It adds a root cron task to run `wattage_apcupsd.sh` every 5 minutes and log the results to `/var/wattaged/watts.log`
 - It adds a logrotate config to rotate the wattaged logs before it gets out of hands
 - Finally, it installs the CLI to the global Python interpreter with `pip install`

The CLI will try reading logs from `/var/log/wattaged`. Since the daemon logs every 5 minutes, wait at least 5 minutes to see the first log appear.

The CLI also displays the price in EUR based on the price per kWh in France in 2021-07-27.

If you want to use the output of `wattage` for something, you can get the Wh value alone by doing:

```sh
wattage 2>/dev/null | cut -f 1
```

as the price in EUR is outputted to stderr, and the Wh value is tab separated from the unit and timespan.

## Development

To install the latest version from Github, run:

```
git clone git@github.com:sam1902/wattaged.git wattaged
cd wattaged
chmod +x install.sh
./install.sh
pip3 install -U .
```

## Usage
```
usage: wattage [-h] [--start START] [--end END] [--logdir LOGDIR]

Computes how much watt-hours were consummed in the time span requested

optional arguments:
  -h, --help       show this help message and exit
  --start START    The start date to compute the consumption, any format recognised by dateutil.parser.parse will work. By default, starts at
                   the last boot time.
  --end END        The end date to compute the consumption. By default computes till the latest record.
  --logdir LOGDIR  The path where .log and .log.gz-ddMMYY are stored
```
