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

    # PLAN!
    # rewrite this function to be a create function that generates a histova object to return
    # set with all the default values from get_default(), ideally this just runs through
    # and pulls all default values to assign to the new object's data slots
    # and then returns object for additional use...
    # REMOVE all use of environments, which should result in the aaa.R file being discarded
    #

    # create a new (and empty) histova object!
    histova <- histova::histova$new()
    # set location

    # both directory and file location strings need to be character types...
    if ((!typeof(location.dir) == "character") || (!typeof(location.file) == "character")) {
        message("FAIL - need to submit character strings for the directory and file names")
        stop()
    }

    # check for existence of file before moving on ONLY when starting a new run
    if ((env.new) && (!file.exists(paste0(location.dir, "/", location.file)) ) ) {
        message("FAIL - file could not be found")
        stop()
    }


    ########### DELETE - THIS IS ALL GOING INTO THE HISTOVA OBJECT
    # check for the existence of the environments
    if ((!exists('the', mode='environment')) || (!exists('fig', mode='environment')) ||
        (!exists('notes', mode='environment')) || (!exists('raw', mode='environment')) ||
        (!exists('stats', mode='environment')) ) {

        message("FAIL - environments not available")
        stop()
    }
    ########### DELETE

    # NEW OBJ
    # file & environments exist! let's get started
    histova$file$location.file <- location.file

    # use dirname function to pull the directory name by appending the given filename to it..
    # this will drop a '/' if it is included in the submitted dirname
    histova$file$location.dir <- dirname(paste0(location.dir, "/", histova$get("file.location.file")))

    # pull the file suffix
    histova$file$location.file.suffix <- histova::get_suffix(histova$get("file.location.file"))
    # remove the suffix AND the separating '.' the gsub drops the last character from the string regardless
    # of what it is - assuming it is a '.'... the '$' in the sub call replaces the suffix at the end of the filename
    histova$file$location.file.name <- gsub('.{1}$', '', sub(paste0(histova$get("file.location.file.suffix"),"$"), "", histova$get("file.location.file")))
    histova$file$location.log <- ""
    histova$behave$log <- saveLog

    # setup the connection needed for the logfile (if in use)
    if (saveLog) {
        histova$file$location.log <- paste0(histova$get("file.location.dir"), "/", histova$get("file.location.file.name"), ".histova")
        if (!histova::is_con_open(histova$get("file.LOG"))) {
            if (env.new) {
                histova$file$LOG <- file(histova$get("file.location.log"), open = "w")
            } else {
                histova$file$LOG <- file(histova$get("file.location.log"), open = "a")
            }
        }
    }

    ########### DELETE - THIS IS ALL GOING INTO THE HISTOVA OBJECT
    # OLD ENV
    # file & environments exist! let's get started
    the$Location.File <- location.file

    # use dirname function to pull the directory name by appending the given filename to it..
    # this will drop a '/' if it is included in the submitted dirname
    the$Location.Dir <- dirname(paste0(location.dir, "/", the$Location.File))

    # pull the file suffix
    the$Location.File.Suffix <- get_suffix(the$Location.File)
    # remove the suffix AND the separating '.' the gsub drops the last character from the string regardless
    # of what it is - assuming it is a '.'... the '$' in the sub call replaces the suffix at the end of the filename
    the$Location.File.Name <- gsub('.{1}$', '', sub(paste0(the$Location.File.Suffix,"$"), "", the$Location.File))
    the$Location.Log <- ""
    the$Log.Save <- saveLog

    # setup the connection needed for the logfile (if in use)
    if (saveLog) {
        #the$Location.Log = paste0(the$Location.Dir, "/", sub("txt$", "histova", the$Location.File))
        the$Location.Log <- paste0(the$Location.Dir, "/", the$Location.File.Name, "DEPRECATED.histova")

        if (!histova::is_con_open(the$LOG)) {
            if (env.new) {
                the$LOG <- file(the$Location.Log, open = "w")
            } else {
                the$LOG <- file(the$Location.Log, open = "a")
            }
        }
    }
    ########### DELETE

    # always print a message with a new run
    if (env.new) {
        histova::histova_msg(sprintf("histova %s", utils::packageVersion("histova")), type="title", breaker = "above")
        histova::histova_msg(sprintf("run on %s", date()), type="title", breaker = "below")
        histova::histova_msg("File exists & data environments ready", type = "head")
    # if not new then printing a message is optional...
    } else if (printMsg) {
        histova::histova_msg(sprintf("resume run on %s", date()), type="title", breaker = "both")
        histova::histova_msg("Data environments ready", type = "head")
    }

    return(histova)
}
