#' histova message
#'
#' @param msg Simple text string to print out / write to file
#' @param type title/head/subhead/msg/warn For what type of print call to use
#' @param breaker above/below/both Should the text string have border lines before and/or after it
#' @param tabs And indentation for the message
#' @param PRINT T/F Print out to screen
#' @param LOG  T/F Write to .histova log file
#'
#' @export
#'
histova_msg <- function(msg, type="msg", breaker=FALSE, tabs=0, PRINT=TRUE, LOG=TRUE) {

    # look into how to best handle warning messages... should they be marked / noted differently in the log file?

    # header code
    breakLength = 80
    headPad = 8
    subHeadPad = 4

    # build the msg up
    if (type == "title") {
        pad = trunc((breakLength - nchar(msg))/2) - 1
        if (pad > 0) {
            msg = paste(gsub(pattern = "0", replace="-", x = sprintf(paste0("%0", pad, "s"), as.numeric("0"))),
                        msg,
                        gsub(pattern = "0", replace="-", x = sprintf(paste0("%0", pad, "s"), as.numeric("0"))))
            if (nchar(msg) < breakLength) { msg = paste0(msg, "-") }
        }
    } else if (type == "head") {
        msg = paste(gsub(pattern = "0", replace="-", x = sprintf(paste0("%0", headPad, "s"), as.numeric("0"))),
            msg,
            gsub(pattern = "0", replace="-", x = sprintf(paste0("%0", headPad, "s"), as.numeric("0"))) )
    } else if (type == "subhead") {
        msg = paste(gsub(pattern = "0", replace="-", x = sprintf(paste0("%0", subHeadPad, "s"), as.numeric("0"))),
            msg)
    }

    if (breaker == "above") {
        msg = paste0(gsub(pattern = "0", replace="-", x = sprintf(paste0("%0", breakLength, "s"), as.numeric("0"))), "\n", msg)
    } else if (breaker == "below") {
        msg = paste0(msg, "\n", gsub(pattern = "0", replace="-", x = sprintf(paste0("%0", breakLength, "s"), as.numeric("0"))))
    } else if (breaker == "both") {
        msg = paste0(gsub(pattern = "0", replace="-", x = sprintf(paste0("%0", breakLength, "s"), as.numeric("0"))),
                    "\n", msg, "\n",
                    gsub(pattern = "0", replace="-", x = sprintf(paste0("%0", breakLength, "s"), as.numeric("0"))))
    }

    if (PRINT) {
        if ((type == "msg") || (type == "title") || (type == "head") || (type == "subhead")) {
            message(msg)
        } else {
            warning(msg)
        }
    }

    if ((LOG) && (the$savePlot)) {
        writeLines(msg, the$LOG)
    }
}
