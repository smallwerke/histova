#' Load File
#'
#' This function loads the settings and data contained in the specified file
#' into the environment. A copy of the data in the file should be saved
#' within a 'raw' variable. The settings can be changed with a backup
#' assumed to be in the initial file. The goal is that once the aesthetic settings
#' are finalized the settings and raw data can be written back out to a file
#' for subsequent re-use.
#'
#' @param location.dir The directory the data file is contained in
#' @param location.file The file containing the data
#' @param savePlot Should the finished plot & log be saved to disk
#'
#' @export
#'
#' @examples
#' load_file("/Users/Shared/HISTOVA_DATA", "test.txt", savePlot = FALSE)
load_file <- function(location.dir, location.file, savePlot) {

    # check for existence of file before moving on
    if (!file.exists(paste0(location.dir, "/", location.file)) ) {
        message("FAIL - file could not be found")
        stop()
    }
    # check for the existence of the environments
    if ((!exists('the', mode='environment')) || (!exists('fig', mode='environment')) ||
        (!exists('notes', mode='environment')) || (!exists('raw', mode='environment')) ||
        (!exists('stats', mode='environment')) ) {

        message("FAIL - environments not available")
        stop()
    }

    # file & environments exist! let's get started
    the$Location.File = location.file
    the$Location.Dir = location.dir
    the$savePlot = savePlot

    # setup the connection needed for the logfile (if in use)
    if (savePlot) {
        the$Location.Log = paste0(the$Location.Dir, "/", sub("txt", "histova", the$Location.File))
        the$LOG = file(the$Location.Log, open = "w")
    }

    histova_msg(sprintf("histova %s", utils::packageVersion("histova")), type="title", breaker = "above")
    histova_msg(sprintf("run on %s", date()), type="title", breaker = "below")
    histova_msg("Prep & Load config settings and data", type = "head")
    histova_msg("file found and environments loaded successfully", tabs=2)

    # prep & load config info / data
    load_file_head()
    # !! EDIT: load_data is also immediately modifying the values it is reading in, break this into
    # a separate step where the data is copied to a new holder with raw$base ALWAYS having the raw file values (in large part to enable writing out and recalc)
    load_data()
}
