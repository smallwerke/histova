#' Histova Message
#'
#' @param msg Simple text string to print out / write to file
#' @param type title/head/subhead/msg/warn For what type of print call to use (title, head & subhead include formatting)
#' @param breaker above/below/both Should the text string have border lines before and/or after it
#' @param tabs Any indentation for the message (only compatible with msg and warn)
#' @param PRINT T/F Print out to screen
#' @param LOG  T/F Write to .histova log file
#'
#' @export
#'
histova_msg <- function(msg, type="msg", breaker=FALSE, tabs=0, PRINT=TRUE, LOG=TRUE) {

    # accept multiple different spellings
    if ((type == "warn") || (type == "warns") || (type == "warning")) { type <- "warn" }

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
    } else if ((type == "msg") || (type == "warn")) {
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
