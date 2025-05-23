#' Load Data
#'
#' @description
#' Load the data in from the file and perform any global manipulations. Following the file header
#' (all lines that begin with '#') comes the data for the figure. The format is
#' value<tab>Group1<tab>Group2
#' Group 2 is optional. The data is displayed in the order it is entered into the file.
#' All data is saved to the histova environment for use by other functions.
#'
#' @export
#'
#' @examples
#' load_data()
load_data <- function () {

    histova_msg(sprintf("Load data (file: %s)", the$Location.File), type="subhead")
    # read in the data
    fullPath <- paste0(the$Location.Dir, "/", the$Location.File)
    rawIN <- utils::read.table(fullPath, sep="\t", header=TRUE, comment.char = '#', check.names = FALSE)

    # save the input data from the file BEFORE doing ANY adjustments whatsoever to it..
    # this allows for subsequent writing of this file back out...
    raw$IN <- rawIN

    histova_msg(sprintf("Data loaded and stored in the raw$IN environment"), type="msg", tabs=1)
}
