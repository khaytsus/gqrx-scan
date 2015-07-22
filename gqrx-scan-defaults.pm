## All command line arguments are listed below and can be set in this file to
## used as the default value and not require specifying these options on the
## command line.  Options specified on the command line will over-ride these
## settings.

## Anything marked with (flag) means it's expecting a boolean type value,
## but basically 0 means false, anything else in Perl will mean true.  Use
## 0 or 1 for sanity.

## Uncomment anything you wish to specify by default and update its value.
## When possible, defaults match those defaults set within the script itself.

## Change the GQRX remote control IP/port to match GQRX settings
#$gqrxip = "127.0.0.1";
#$gqrxport = "7356";

## Change the location of the pause file
#$pausefile = "/home/wally/.gqrx-pause.txt";

## Change the gqrx log file output
#$logfile = "/home/wally/gqrxscan.log";

## Set a default config file to use
#$config = "/home/wally/gmrs.pm";

## Set the file type to use by default.  gqrxfile, file, and scan are possible options
#$type = "gqrxfile";

### Scan mode options ###

## What demodulation mode to use.  See documentation for the complete list
#$mode = "usb";

## What frequency to start scanning from in hz
#$start = "28,4e6";

## What frequency to stop scanning in hz
#$end = "28.6e6";

## Distance between scan mode steps in hz
#$step = "1000";

### file or gqrxfile mode options ###

## Filename to use for "file" mode
#$csvfilename = "/opt/gqrx-remote/gqrx-bookmarks.csv";

## Filename for "gqrxfile" mode
#$gqrxcsvfilename = "/home/wally/.config/gqrx/bookmarks.csv";

## What channel or channels to scan, separated by commas
#$channel = "1,4";

## Show all frequencies or channels, even if skipped or not part of tag or pattern (flag)
#$showall = "1";

## What pattern to tune to, matches frequency or channel name
#$pattern = "14[6][7]";
# In gqrxfile mode, what tag or tags to tune, separated by commas

##$tags = "GMRS";

## Sort channels as they are scanned (flag)
#$sort = "1";

### Common File or Scan mode options ###

## Frequences to skip when scanning
#$exclude = "144.390e6";

## Signal level at which to delay scanning to the next frequency if set to wait or stop
#$delaylevel = "-40";

## Time in seconds which scanning waits before going to the next channel after signal detection
#$delaytime = "5";

## Time to wait before moving onto the next frequency when scanning.  Lower values can
## make scan speed faster but may miss a busy frequency
#$pause = "0.5";

## Stop when a busy frequency is found, user must hit enter to proceed (flag)
#$stop = "0";

## Wait until the frequency is clear before proceeding, otherwise proceeds after $delaytime (flag)
#$wait = "1";

## Wait $delaytime before proceeding if a busy frequency is detected (flag)
#$levelstop = "1";

######
## Tell GQRX to record if a busy frequency is detected (flag)
#$record = "1";

## Monitor a single frequency for activity (optimized display for single vs scanning) (flag)
#$monitor = "0";

### Display or informative options

## Show all available channels in file and exit (flag)
#$dumpchannels = "0";

## Show color output (flag)
#$coloroutput = "1";

## Optimize for dark (0) or light (1) background terminals
#$light = "0";

## Change if we send ANSI codes to clear the terminal or not (flag)
#$clearscreen = 1;

## How many seconds do we wait before printing a summary in the logfile
#$logheader = 600;

1;
