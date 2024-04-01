#' Read Example
#'
#' @param path The name of the file being searched for
#'
#' @return files associated with the package if path is NULL, the file location for a specific file if defined or error
#' @export
#'
histova_example <- function(path = NULL) {
    if (is.null(path)) {
        dir(system.file("extdata", package = "histova"))
    } else {
        system.file("extdata", path, package = "histova", mustWork = TRUE)
    }
}
