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

    ############################################
    # LOAD FILE (OPTIONS & DATA) - NOTHING MORE
    load_file(location.dir, location.file, savePlot)

    ############################################
    # PREP DATA ADJUSTMENTS
    run_data()

    ############################################
    # RUN STATS
    run_stats()

    ############################################
    # BUILD FIGURE
    build_figure(printPlot, savePlot)
}
