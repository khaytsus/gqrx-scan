gqrx-scan
================

Control GQRX to scan frequencies or from channels using a CSV file.  The CSV file can either be the file which GQRX itself creates using its built-in bookmarking functionality or the CSV style which gqrx-remote uses.  More details are at the bottom of this readme.

### High level functionality
  * Scan a range of frequencies with a specified mode (AM, FM, etc) or a csv file
  * Monitor a single frequency or channel, pair with record etc to quickly record activity on a channel etc
  * Exclude specific frequencies (birdies, interference, etc)
  * Exclude specific channel names
  * Scan a range of channels or a list of channels
  * Scan a pattern of channels by name or frequency
  * Resume scan from current frequency or channel
  * Colorize output
  * Default and optional config files can be defined

### Signal Detection
  * Pause scanning when a signal level threshold is met
   * Pause for N seconds, until clear, or until the enter key is hit
  * Record audio
 
### Example usage scenarios..

 * Scan entire CSV file with a pause of 2s between channels
  * gqrx-scan --type file --pause 2

 * Scan entire GQRX CSV file with a pause of 2s between channels
  * gqrx-scan --type gqrxfile --pause 2

 * Scan all lines matching the tags 2M or 70cm
  * gqrx-scan --type gqrxfile --tags "2M|70cm"

 * Scan lines 1, 2, and 40 through 60 in the file, recording when a signal is detected
  * gqrx-scan --type file --channels 1,2,40-60 --record

 * Scan FRS, GMRS, and all 145, 146, and 147 frequency channels
  * gqrx-scan --type file --pattern "FRS|GMR|14[5|6|7]"

 * Scan 28.400 to 28.410 in CW mode, pausing for a signal level of -30 for 10s
  * gqrx-scan --type scan --start 28400000 --end 28410000 --mode CW --delaylevel=-30 --delaytime 10
  * 28.400e6 is valid too and might be easier to type/read
  * Available modes: AM FM WFM WFM_ST LSB USB CW CWL CWU

 * Monitor a single channel, recording when the level is better than -50, waiting for 5 seconds before ending recording after signal drops
  * gqrx-scan --type file --channels 20 --delaylevel=-50 --delaytime 5 --record --monitor

 * Use a config file
  * gqrx-scan --config /home/path/something.pm

### Command Line Arguments

Notes:

You can abbreviate command line arguments as long as they're unique, such as --co is unique for --coloroutput.  If the argument is not unique it will be ignored and you will see a warning.

The following arguments can take a "no" prefix to over-ride config file values:  stop wait record monitor coloroutput light sort

ex:  --norecord

##### Scan mode operations

 * --start 28400000
  * Start at frequency 28.400
 * --end 28410000
  * Stop at frequency 28.410
 * --mode USB
  * Scan in USB demodulation
 * --step 250
  * Step by 250hz in frequency scanning mode

##### gqrxfile or file mode options

  * --channels 19,20,30,40-50
    * Scan channels 19, 20, 30, and channels 40 through 50
  * --pattern "FRS|GMR|^145"
    * Scan channels named FRS or GMR or frequencies starting with 145
  * --tags "2M|Air"
    * Scan channels tagged 2M or Air
  * --sort
    * Sort CSV file contents by name alphabetically
  * --showall
    * Show all channels even if skipped
  * --csvfilename
    * Specify generic CSV file to use
  * --gqrxcsvfilename
    * Specify GQRX CSV file to use
  * --dumpchannels
    * Show all channels, do not tune any

##### General scan or file options

  * --monitor
    * Monitor a single frequency or channel
  * --pause 2
    * Wait 2 seconds between frequencies/channels
  * --exclude 28.401e6,28.410e6,KY4
    * Exclude frequency 28 401 and 28 410 or channel with KY4 in it

##### Signal detection options

  * --delaylevel=-30
    * Delay scanning or record if a signal of -30 or better is heard
    * Note that this argument requires the equal sign
  * --ignorelevel=99
    * Ignore any level that comes back as this value, such as invalid data
    * Defaults to 0.0
  * --delaytime 10
    * Delay scanning for 10s when a signal is detected
  * --record
    * Record when signal is detected
  * --stop
    * Stop scanning until the enter key is hit
  * --wait
    * Stop scanning until the channel is clear
  * --levelstop=0
    * Do not pause to listen for signal
    * Note the requirement of the equal sign

### Config File

A configuration file can be defined to set any option that is available on the command line to allow quick pre-configurations, such as scanning 10M CW or all GQRX CSV File entries with "GMRS"

The config file is a perl module and must be treated as such.  An example has been included, gqrx-scan-defaults.pm and should be in your $HOME if you want to use it as a default, but it is not required.  It has examples of every option that can be specified on the command line.

Options specified on the command line over-ride those in both the default and command-line specified config files to allow testing or temporary altering of gqrx-scan behavior.  To over-ride certain options, such as record, you must use the --no prefix, such as --norecord

Options are set in the following order, each subsequent one could over-ride the previous one:  script, default config file, optional config file, command-line arguments

Some useful example config files are in the Examples directory.

### CSV File Sort

The --sort option is included if you want to sort the GQRX CSV file iteration by the channel name rather than by the natural sort of the file in case you want to group channels by name.  This is handy when you are monitoring 5 channels of a common set of frequencies but they are in different places on the spectrum, this will allow you to show CHAN1 CHAN2 etc rather than by order of frequency.  It is not valid to sort the generic CSV as the available columns between the two files are different.

### Incompatable options

There are some options which will not work together or may cause unexpected side-effects.  The following are a few examples of such conflicts.

  * --type file --tags
    * Tags is not valid in the generic CSV file mode, only the gqrxfile mode has tags

  * --type file --sort
    * Sorting is not valid in the generic CSV file mode due to differences in CSV file contents

  * --type file/gqrxfile --channel 1 --pattern "ABC"
    * Channel and Pattern are exclusive options as they are handled slightly differently

  * --type gqrxfile --channel 1 --tags "ABC"
    * Channel and tags are exclusive options as they are handled slightly differently

Combinations which will display a warning

  * --type gqrxfile --channels 1-5 --sort
    * Will likely sort the channels in a different order than they are in the file (ie:  Might scan different channels than you expect)

### Defaults vs Command Line

There are options in the script which can be modified to set them as defaults but almost all options (such as signal detection level, scan pause time, etc) can be specified on the command line.  To see the script defaults look in the script or the output of the --help command line argument.

### Bookmarks file

If using the gqrxfile mode, the CSV file in $HOME/.config/gqrx/bookmarks.csv will be used.  This is the file which GQRX uses for its built-in bookmarking system and contains the frequency, channel name, modulation, bandwidth, and optional tags.  Note, bandwidth is not used by GQRX Scan at this time as the GQRX Remote command set does not support setting bandwidth currently.

Otherwise, you may use the generic "file" mode which is a CSV file that can be used for scanning pre-set channels is the same format as the gqrx-remote project (https://github.com/marmelo/gqrx-remote) uses, without any headers, with the columns being HZ,MODE,Name

The CSV file path is defined in the file and should be updated for where your file is located.

Example:

28101000,CW,10m CW<br>
28400000,USB,10m Calling<br>
446000000,FM,440 Simplex<br>
144200000,LSB,2m SSB Calling<br>

### Recording Tips

Be sure you set the GQRX LNA Gain to a sane, static value and not Hardware AGC or your recording won't be reliable.

The squelch in GQRX must match the delaylevel or you might might miss recordings that GQRX is hearing or record noise after the transmission ends that GQRX would otherwise squelch.  Ideally set the squelch slightly more open in GQRX, example:  delaylevel equals -54, set GQRX to -60.  If you hear the recordings squelching too much during recording, tweak the GQRX squelch to open a little easier.

### Silent/Review Scripts

This pair of scripts are provided to make cleaning up empty mp3 files created by record mode and reviewing them easier.  You will have to modify the paths that you store recordings and possibly tweak which tools you wish to use to review them.

### Pause Script

With this script, you can pause the scanning using a hotkey.  How you assign that hotkey is up to your particular desktop environment.  The first time ran it creates a file that GQRX Scan uses to pause, the second time it removes it.  GQRX Scan removes this file on startup in case it's left over.

### Troubleshooting

  * Perl Issues
   * Check your dependencies
   * Your distribution most likely packages the requirements, look for them there before going to CPAN or other repositories
  * Command Not Found type errors when running the scripts
   * Run gqrx-scan directly with perl, or set the script as executable.
   * Note that the script might not be in your executable path, so even if set executable you may have to run it with the full or relative path, ie:  ./gqrx-scan
  * Cannot connect to GQRX
   * Make sure the remote configuration is set to include 127.0.0.1 and ::ffff:127.0.0.1 and the script is pointing to 127.0.0.1
   * Make sure the port is 7356 or that the script settings are using that port
   * Make sure the GQRX remote is enabled (you must enable it every time you start GQRX)

### Dependencies

  * GQRX 2.3 or greater with Remote Control enabled

  * GQRX 2.4 to have the GQRX Bookmarks file available

  * Perl modules
   * Net::Telnet
   * Time::HiRes
   * Getopt::Long

  * Optional Perl modules
   * Term::ANSIColor

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/khaytsus/gqrx-scan/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

