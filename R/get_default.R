#' Get Default Value
#'
#' Submit an environment and variable name and get returned the default value.
#' NULL response indicates unable to find environment and/or variable.
#'
#' @param envName text of the environment
#' @param varName text of the variable
#'
#' @returns value from env, NULL if not found
#' @export
#'
#' @examples
#' get_default('the', 'envList')
get_default <- function(envName, varName) {

    if ( (envName %in% names(default_vals)) && (varName %in% names(get(envName, default_vals))) ) {
        return (get(varName, get(envName, default_vals)) )
    }
    return (NULL)
}
