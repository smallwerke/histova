#' Generate Figure
#'
#' @description
#' This is the main function that builds a plot based on the specified configuration file. Pass in
#' the desired directory and file name in string format. By default the function does not print the
#' resulting plot but does save the plot and a log file in the same directory where the configuration
#' file is located.
#'
#' The configuration file must end in .txt and follow a specific format. The resulting plot and log
#' files both take the same name as the config file and simply changes the file extension. The plot
#' type is specified in the config file (default is .jpg) and the log file is set as .histova.
#'
#' This function is a basic wrapper function for the following three main functions:
#' load_file()
#' run_data()
#' build_figure()
#' These can be run individually to the same effect. Functions are in development to allow editing and
#' setting of settings for use in developing what the finished figure will look like (e.g. color and fonts).
#'
#' @param location.dir The directory the data file is contained in
#' @param location.file The file containing the data
#' @param printPlot Should the finished plot be printed
#' @param savePlot Should the finished plot & log be saved to disk
#'
#' @export
#'
#' @examples
#' generate_figure("/Users/Shared/HISTOVA_DATA", "test.txt", savePlot = FALSE)
#'
generate_figure <- function(location.dir, location.file, printPlot = FALSE, savePlot = TRUE) {

    ##########################################
    # using following pages as guides:
    # https://cran.r-project.org/web/packages/rcompendium/vignettes/developing_a_package.html
    # https://r-pkgs.org/whole-game.html#use_readme_rmd
    # working on:
    # https://r-pkgs.org/testing-design.html
    # Plans for the next steps of this package
    # - PACKAGE FUTURE:
    # - breakout generate_figure process into three main steps
    #       - Load File: load the header & data into the environment (don't do any stats or modifications to it - goal is to always have a 'raw' copy of data)
    #       - Process Data: run stats and process data according to settings (keep a 'raw' copy)
    #       - Generate Figure: create the actual figure and display/save it...
    #       - ** transition generate_figure to simply call these three functions in order making generate_figure even more of a basic wrapper **
    # - this will allow the addition of some useful commands / features
    #       - print settings: print out all of the display / stats / etc. settings from the header file
    #       - print data & groups: output information about the loaded groups
    #       - modify settings: change setting information (colors, titles, size, etc etc) with the option to rerun stats and/or generate figure
    #       - write settings: once the settings produce the desired figure the ability to write the settings & raw data BACK OUT as a file...
    # - TESTING DEV:
    # - setup tests using the saved *.rda files within the package strucutre
    #       appears to work loading test scripts into int/extdata and then calling the location with:
    #       generate_figure(str_remove(histova_example("test.txt"), "/test.txt"), "test.txt")
    #           depends on stringr package!
    #           one note is that every call / modification of a gplot will impact the gplot OBJECT and thus the data in the saved rda (must follow the same process)
    #           the gplot object - for some strange reason - contains copies of the local environment ON EACH MODIFICATION?!
    # - run the ugly tests behind the scenes for functionality testing, where in the structure should the .txt files be saved?
    #       - actually reformat these to look good and include them in the examples directory, maybe have a funky one remain to show the width options...
    #       - another OPTION is to built thorough R data files, load them into the appropriate environment for the test at hand and just run that function on the engineered environment
    # - check the results of these tests against the pre-generated & saved rda files
    # - resolve all of the current min / max and other errors that are appearing
    #       Some are occasionally appearing in combination with y-axis break & HLines... Overall not often though
    #       appears to address it: https://cran.r-project.org/web/packages/ggplot2/vignettes/ggplot2-in-packages.html
    #       *** have changed the subset calls in build_histo to use R's base & more traditional subset method, should work but... ***
    # - include nice / well designed versions of the current test designs in the readme.rmd page
    # - have the color assignments have an actual group1/group2 name to them to assign them based on name not simply order
    #       this is largely being handled in set_aesthetics
    #       1: potentially allow a user to specify the order of the display in the config (run this before setting Colors) BUT probably best
    #           to not have a order check running as default since with facet off and unique G1 names they might want to intermix them?
    #       2: go through all of the test files and make sure they are still functioning with the new COLORS UNIQUE setting
    # - after getting the colors fixed build:
    #       - for violin/box plots unclear how the number of data points is being decided BUT currently the 'default' Colors Alpha is used for all groups regardless of Unique or Specific setting
    #       - review how the raw data is being stored and then calculated / analyzed... look into making sure a copy of the raw data remain stored somewhere
    #           - check through all the options in histova and map out the best way to have a data summary / overview for the figure generation
    #               - eg final group names even when displayed as G1 for both G2s (currenlty using raw$summary)
    #       - function to display statistical settings in environment
    #       - function to display aesthetic settings in environment
    #           - check to make sure that after running through standard 'generate_figure' that all of the original variables are STILL in the env (eg you can generate the SAME figure stats, transformations & all just from the env)
    #               - document all calls to init_vars...
    #       - function to build figure from variables loaded into environment
    #       - function to run stats on data based on environment settings (always go back to raw loaded data)
    #       - functions to edit stats & aesthetic settings in the environment
    #       - function to write config&data file from environment variables
    # - potentially have a config option to order the display of groups? currently having G2 data in G1 causes issues...
    # - add a function for generating the config file header section (have R run through a series of prompts and spit out a file header!)
    #       include option to generate a batch version where you can load the generated config file and all you would be editing are
    #       the Labels, Groups (opt?), Stats tests run and it would all be reusing the 'batch' file's style settings (similar to override)
    # - DONE: add ability to not have all G1 in each G2... should be able to have distinct G1 per G2...
    #       this is an issue in ggplot2 on build_histo lines 244 & 258... easy enough to drop unused G1 with scales=free_x but this breaks coord_fixed...
    #       currently have the ability to only display the active G2 & G1 combinations BUT have turned off the coord_fixed option
    #       active in init_vars(), load_file_head() & build_hist()
    # - Having a y-break active the plot fills the width of the set area better, switching to ymin or nothing set and the plot suddenly becomes square -
    #       could this be an issue with coord_ratio? ** this appears to be fixed when running with the latest code **


    ##########################################
    # LOAD FILE
    load_file(location.dir, location.file, savePlot)


    ##########################################
    # RUN STATS
    run_data()


    ##########################################
    # BUILD FIGURE
    build_figure(printPlot, savePlot)

}
