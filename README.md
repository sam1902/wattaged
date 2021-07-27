# wattaged

Wattage Daemon is a utility that logs the consummed electricity and allows you to quickly compute the consummed kWh

## Getting started

To install the CLI, run the following:
```sh
git clone git@github.com:sam1902/wattaged.git wattaged
cd wattaged
./install.sh
wattage --help
```
The install script does a lot of things:
 - It moves the `wattage_apcupsd.sh` script to `/opt/wattaged`
 - It adds a root cron task to run `wattage_apcupsd.sh` every 5 minutes and log the results to `/var/wattaged/watts.log`
 - It adds a logrotate config to rotate the wattaged logs before it gets out of hands
 - Finally, it installs the CLI to the global Python interpreter with `pip install`

The CLI will try reading logs from `/var/log/wattaged`. Since the daemon logs every 5 minutes, wait at least 5 minutes to see the first log appear.

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
