#' Initialize variables to defaults
#'
#' @return nothing
#' @export
#'
#' @examples
#' init_vars()
init_vars <- function() {

    if (!exists("Override", envir=the)) { the$Override <- FALSE }


    ################ Title & Axis Labels (REQ) ################
    the$Fig.Title <- ""

    ################ Height of Y-axis and Horizontal Line/s (REQ) ################
    the$Fig.Y.Min <- 0
}
