#' Check for Env & Var
#'
#' Simple function to do the routine checking of if an environment & variable
#' exists. T/F is the return, a warning message is also thrown if msg is TRUE (default).
#' Msg can be set to FALSE when checking to ensure env or var doesn't exist.
#' If var is left at NULL it will only check for environment.
#'
#' @param envName text of the environment
#' @param varName text of the variable name
#' @param msg T/F should a message be printed?
#'
#' @returns T/F if both exists
#' @export
#'
#' @examples
#' env_var_exists("the", "envList")
env_var_exists <- function(envName, varName=NULL, msg=TRUE) {

    # start by checking if the environment exists, given that we're looking for variables
    # within the environment don't bother checking for the variable if the environment
    # doesn't exist...
    if (!exists(envName, mode='environment')) {
        if (msg) {
            histova_msg(sprintf("ENVIRONMENT \'%s\' does not exist!", envName), type="warn")
        }
        return (FALSE)
    }

    # only arrive here if the environment does in fact exist so we can safely call get(envName)
    if (!is.null(varName)) {
        if (!exists(varName, envir=get(envName))) {
            if (msg) {
                histova_msg(sprintf("VARIABLE \'%s\' does not exist!", varName), type="warn")
            }
            return (FALSE)
        }
    }
    # assume if both previous checks have passed then the environment AND variable were found
    # and we can safely return TRUE... no messages printed when the checks pass...
    return (TRUE)
}

#' Return file suffix
#'
#' Return the text following the final '.' in the name. If
#'
#' @param location.file text string of the filename
#'
#' @returns text string, NULL if not found or too short
#' @export
#'
#' @examples
#' get_suffix("file.txt")
get_suffix <- function(location.file) {

    if ((typeof(location.file) == "character") && (length(strsplit(location.file, split="\\.")[[1]]) > 1) ) {
        # simply returning the text after the final '.' in a filename
        return (strsplit(location.file, split="\\.")[[1]][length(strsplit(location.file, split="\\.")[[1]])])
    } else {
        return (NULL)
    }
}

#' Is Valid Color?
#'
#' Send in a variable to see if it is an acceptable color with R, checks against
#' various notations including transparant values
#'
#' @param color variable to be checked if it is a R color
#'
#' @returns TRUE if color, FALSE if not
#' @export
#'
is_color <- function(color) {
    isCol = FALSE
    tryCatch({
        isCol = is.matrix(grDevices::col2rgb(color))
    }, error = function(e) {
        isCol = FALSE
    })
    return(isCol)
}

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

#' Is Numeric
#'
#' Is the value a legit number or not, this includes decimals and negatives
#'
#' @param num variable to be checked if it is a number
#'
#' @returns TRUE if numeric, FALSE if not
#' @export
#'
is_num <- function(num) {

    if (!is.na(suppressWarnings(as.numeric(num)))) {
        return (TRUE)
    } else {
        return (FALSE)
    }
}
