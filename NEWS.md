# histova (development version)
## To Do:
- include ability to process group with all 'NA' values (deal with color array and stats test better)
- include option for other post hoc tests
- special characters in the legends & title are buggy - sometimes unicode doesn't display correctly:
      generate_figure has attempts at working on this, main issue is mixing strings & expressions...
- accept a '-' in the x-axis labels
- better display / sizing of the figure for export & saving of output (e.g. R shiny)
- auto guess the YMax value (using upper in the summary table) and the Stat Offset for variable letter sizes
- disabled PTTest option, now can set STTest to be paired and set the variance (equal or unequal), need to add WTTest for Wilcox
- added BASIC whisker & violin plot display option, still need to add option to customize (e.g. whiskers)

# histova v3.5.0
**Initial CRAN submission.**
- transferred script to packge form
- resolved all CMD check issues


# histova v3.4.3
## fixed
- ggplot2 update (size -> linewidth), updated ggsave option to use cairo library for font embedding
# histova v3.4.2
## added
***HLine backwards compatibility is impacted for any previous figure with multiple lines in one HLine setting this will cause issues***
- can now edit lines and markdown format some titles (plot & x-axis - bold & italics; color or boxes not yet supported)
- replace \n with <br>; some combinations of ~ throw <del> not supported error...
- HLine editing is possible with an override & backup setting available (HLines assume backup values unless specified, OVRD will apply to all regardless)
- new section (Chart Line Designs) in config files, **all font defaults to standard weight, bold default DROPPED**
# v3.4.1 status
## added
- ability to add y-axis breaks into the config file with "Y Break->start,stop,scale" scale is optional
- auto move ANOVA stats letters down below when using negative values
- increased support for colors and individual data points, added legend options as well as ability to edit bar width and borders
# v3.4 status
## added
- ability to generate a figure without running any statistical tests
- run t-tests POST transformation on data again (may NOT be necessary... investigate)
- ability to have individual data points to histogram
- incorporate multiple HLine's (**NO LONGER SUPPORTING MULTIPLE HLINEs IN ONE ENTRY as of 3.4.2**)
- handle special characters in the config file for titles & group names
- option for 'global settings' function that allows one to over-ride numerous settings for batch figure generation
- options to specify saved file sizes and dimensions
# v3.3 status
## added
- statistical test options (t-test options, student & wilcox paired) with ability to set the tails (two.sided, greater, less)
- data transform: ability to generate treatment/ control figures & 'mute' select groups (eg for treatment/ control)
- edited 2.4 to allow files with only one group - edits done in the stats call to ignore importing Group2 from the data
- time course transformation added -> Group1 sets the time, Group2 is the group -> impacts spacing of bars
- streamlined the config files - many options are now defaulted in the R script and can be changed in config if desired
# v3.2.4 status
## added
- option to auto control the ratio (SQUARE is now an input) -> largely DEPRECATED with gsave()
- ability to rotate the X-axis values AND consistent sizing between axis & statistical lettering
- ability to manipulate the values (eg divide all by 1,000) and label or use scientific notation
# histova v3.2.3 status
## added
- option to control the figure's ratio enabling one to produce a 'square' or various rectangles...
# histova v3.2.2
## added
- ability to define the distance between the axis title and the tick values
- ability to set the stats caption text size in the config file
- updated init_vars to set default values
# histova v3.2.1 
## added
- check that there are enough values to perform outlier checks (> 2)
# histova v3.2 
## added
- ability to handle multiple Group2 ids for data partitioning and display,
- can now run stats on each Group2 individually or on the entire dataset
- can also chart data based on Group2 subgroupings
- new variables added to config file: Colors; Stats Anova Group2; Facet Split
- for groups / comparisons with no data the script should warn and gracefully deal with
     eg all 0's should simply produce '--' for each stats letter that no stats can be run...
- does a best guess at the Stat Letters Offset value based on the YMax value for export sizes of 1600x831
- add small notes to the bottom automatically that CAN be cropped detailing the stats that were run
    also any 1 or 2 tailed outlier removal, etc...
