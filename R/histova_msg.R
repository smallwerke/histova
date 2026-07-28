#' Histova Message
#'
#' @param msg Simple text string to print out / write to file
#' @param type title/head/subhead/msg/warn/verbose For what type of print call to use (title, head & subhead include formatting)
#' @param breaker above/below/both Should the text string have border lines before and/or after it
#' @param tabs Any indentation for the message (only compatible with msg and warn)
#' @param PRINT T/F Print out to screen
#' @param LOG  T/F Write to .histova log file
#' @param hsa R6 histova object for settings details
#'
#' @export
#'
histova_msg <- function(msg, type="msg", breaker=FALSE, tabs=0, PRINT=TRUE, LOG=TRUE, hsa=NA) {

    # !!!!!!!!!!!
    # once histova objects are implemented it will be required in order to succesfully LOG any messages...
    # also set PRINT & LOG to be pulled from setting in histova object as this is worked through...

    # if a histova object is being supplied assume the log & print settings from
    # the object and override the function call inputs with plan to remove them entirely
    if (class(hsa)[1] == "HISTOVA") {
        PRINT = hsa$get("behave.print")
        LOG = hsa$get("behave.log")
    }

    # accept multiple different spellings
    if ((type == "warn") || (type == "warns") || (type == "warning")) {
        type <- "warn"
    #
    } else if ( (type == "verbose") || (type == "v") ) {
        # current approach is to simply allow print & log if verbose is set to anything but FALSE
        if ( (class(hsa)[1] == "HISTOVA") && isFALSE(hsa$get("behave.verbose")) ) {
            type <- "msg"
            PRINT <- FALSE
            LOG <- FALSE
        # when verbose is on assume function log & print behavior
        } else {
            type <- "verbose"
        }
    } else if ( (type == "debug") || (type == "bug") ) {
        if ( (class(hsa)[1] == "HISTOVA") && isFALSE(hsa$get("behave.debug")) ) {
            type <- "msg"
            PRINT <- FALSE
            LOG <- FALSE
        # when debug is on assume function log & print behavior
        } else {
            type <- "debug"
        }
    }

    # look into how to best handle warning messages... should they be marked / noted differently in the log file?
    # IF it is a warning message save a copy so that any indents or alterations aren't sent through to warning()
    if (type == "warn") { warnMsg = paste0("FROM ", deparse(sys.calls()[[sys.nframe()-1]]), ": ", msg)  }

    if ((exists("MUTE", where=the)) && (the$MUTE)) { PRINT <- FALSE }

    # header code
    breakLength <- 80
    headPad <- 8
    subHeadPad <- 4

    # build the msg up
    if (type == "title") {
        pad = trunc((breakLength - nchar(msg))/2) - 1
        if (pad > 0) {
            msg <- paste(gsub(pattern = "0", replacement = "-", x = sprintf(paste0("%0", pad, "s"), as.numeric("0"))),
                        msg,
                        gsub(pattern = "0", replacement = "-", x = sprintf(paste0("%0", pad, "s"), as.numeric("0"))))
            if (nchar(msg) < breakLength) { msg = paste0(msg, "-") }
        }
    } else if (type == "head") {
        msg <- paste(gsub(pattern = "0", replacement = "-", x = sprintf(paste0("%0", headPad, "s"), as.numeric("0"))),
            msg,
            gsub(pattern = "0", replacement = "-", x = sprintf(paste0("%0", headPad, "s"), as.numeric("0"))) )
    } else if (type == "subhead") {
        msg <- paste(gsub(pattern = "0", replacement = "-", x = sprintf(paste0("%0", subHeadPad, "s"), as.numeric("0"))),
            msg)
    } else if ((type == "msg") || (type == "verbose") || (type == "debug") || (type == "warn")) {
        if (type == "verbose") {
            msg <- paste0("V: ", msg)
        } else if (type == "debug") {
            msg <- paste0("D: ", msg)
        }
        if ((tabs > 0) && (tabs < 16)) {
            indent <- tabs * 4
            msg <- paste0(gsub(pattern = "0", replacement = " ", x = sprintf(paste0("%0", indent, "s"), as.numeric("0"))), msg)
        }
    }

    if (breaker == "above") {
        msg = paste0(gsub(pattern = "0", replacement = "-", x = sprintf(paste0("%0", breakLength, "s"), as.numeric("0"))), "\n", msg)
    } else if (breaker == "below") {
        msg <- paste0(msg, "\n", gsub(pattern = "0", replacement = "-", x = sprintf(paste0("%0", breakLength, "s"), as.numeric("0"))))
    } else if (breaker == "both") {
        msg <- paste0(gsub(pattern = "0", replacement = "-", x = sprintf(paste0("%0", breakLength, "s"), as.numeric("0"))),
                    "\n", msg, "\n",
                    gsub(pattern = "0", replacement = "-", x = sprintf(paste0("%0", breakLength, "s"), as.numeric("0"))))
    }

    if (PRINT) {
        message(msg)
        if (type == "warn") { warning(warnMsg, call. = FALSE) }
    }

    if (exists("Log.Save", where=the) && (LOG) && (the$Log.Save)) {
        # check for the connection, if not open give it another try...
        #if (!is_con_open(the$LOG)) {
            #set_env(the$Location.Dir, the$Location.File, the$Log.Save, env.new = FALSE, printMsg = TRUE)
        #}
        if (is_con_open(the$LOG)) {
            writeLines(msg, the$LOG)
        }
    }
}
