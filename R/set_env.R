#' Setup the environment
#'
#' This function sets up the general environment, checking to make sure
#' the needed environments for data & options storage exist and
#' that the specified file exists
#'
#' The log file is also initiated here.
#'
#' @param location.dir The directory the data file is contained in
#' @param location.file The file containing the data
#' @param saveLog Should the log be saved to disk
#' @param env.new T/F is this a new environment or continued execution on an old one
#' @param printMsg T/F print a resume header message, only option when env.new is FALSE
#'
#' @export
#'
#' @examples
#' set_env("/Users/Shared/HISTOVA_DATA", "test.txt", saveLog = FALSE)
set_env <- function(location.dir, location.file, saveLog, env.new = TRUE, printMsg = TRUE) {

    # check for existence of file before moving on ONLY when starting a new run
    if ((env.new) && (!file.exists(paste0(location.dir, "/", location.file)) ) ) {
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
    the$Location.File <- location.file
    the$Location.Dir <- location.dir
    the$Location.Log <- ""
    the$Log.Save <- saveLog

    # setup the connection needed for the logfile (if in use)
    if (saveLog) {
        the$Location.Log = paste0(the$Location.Dir, "/", sub("txt", "histova", the$Location.File))

        if (!is_con_open(the$LOG)) {
            if (env.new) {
                the$LOG <- file(the$Location.Log, open = "w")
            } else {
                the$LOG <- file(the$Location.Log, open = "a")
            }
        }
    }

    # always print a message with a new run
    if (env.new) {
        histova_msg(sprintf("histova %s", utils::packageVersion("histova")), type="title", breaker = "above")
        histova_msg(sprintf("run on %s", date()), type="title", breaker = "below")
        histova_msg("File exists & data environments ready", type = "head")
    # if not new then printing a message is optional...
    } else if (printMsg) {
        histova_msg(sprintf("resume run on %s", date()), type="title", breaker = "both")
        histova_msg("Data environments ready", type = "head")
    }
}
