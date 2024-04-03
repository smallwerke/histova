#' histova message
#'
#' @param msg Simple text string to print out / write to file
#' @param type msg/warn For what type of print call to use
#' @param breaker Should the text string have border lines before and/or after it
#' @param tabs And indentation for the message
#' @param PRINT T/F Print out to screen
#' @param LOG  T/F Write to .histova log file
#'
#' @export
#'
histova_msg <- function(msg, type="msg", breaker=NULL, tabs=0, PRINT=TRUE, LOG=TRUE) {

    # look into how to best handle warning messages... should they be marked / noted differently in the log file?

    if (PRINT) {
        if (type == "msg") {
            message(msg)
        } else {
            warning(msg)
        }
    }
    if (LOG) {
        writeLines(msg, the$LOG)
    }
}
