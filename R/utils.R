#' Is Connection Open
#'
#' Send in a variable that might be a connection to check... this simply catches
#' the error thrown by base::isOpen when a variable is sent in that has already
#' been closed...
#'
#' @param con variable to be checked if it is a file connection
#'
#' @returns TRUE if open, FALSE if not open or not connection
#' @export
#'
is_con_open <- function(con) {
    tryCatch({
        isOpen(con)
    }, error = function(e) {
        FALSE  # If error occurs, connection is closed/invalid
    })
}
