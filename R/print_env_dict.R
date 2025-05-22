#' Print Environment Dictionary
#'
#' Simple and largely internal function that traverses a pseudo dictionary composed of environment variables
#' to dynamically print out variable information that this package depends on. Function is designed to be a
#' guide for editing or loading settings for figure design to allow for customization of figure
#' while loaded in R.
#'
#' @param env the environment object to traverse
#' @param name name of the environment object for human printing
#' @param rootEnv the environment that actually contains the data
#' @param depth in num of tabs for printing out dictionary tree
#' @param includeData T/F should data be printed out alongside name
#'
#' @returns depth of print in tabs
#' @export
#'
print_env_dict <- function(env, name, rootEnv, depth = 0, includeData = TRUE) {
    # assume this will only ever be called on an environment go ahead and print it as such...
    # BUT only if the depth is at 0 or greater... -1 is used for indicating the base environment
    # to start from and not bother printing that environment name...
    if (depth >= 0) {
        # wherever actual data is stored gets an entry appended with '-root_val' to the environment name
        # this environment entry contains the full name of the variable for printing & reference
        # IF this is found at this environment level get the stored value and print out both
        if ((exists(paste0(name,"-root_val"), envir=env)) && (!is.environment(get(paste0(name, "-root_val"), envir = env)))) {
            # grab the loaded variable name
            value <- get(paste0(name, "-root_val"), envir = env)

            if (includeData) {
                # grab the variable data from the actual environment
                value_data <- get(value, envir=rootEnv)
            } else {
                value_data <- ""
            }

            # determine the depth to print out this msg with the assumption that the current max depth is FIVE
            # and the lower the level the greater the padding is required for the variable name
            histova_msg(sprintf("%-*s%-25s%s", (((5-depth) * 4) + 12), name, value, substr(toString(value_data), 1, 40)), tabs=depth, type="msg", LOG=FALSE)
        } else {
            # when no "-root_val" name exists go ahead and print out the name where no data is stored at the appropriate depth
            histova_msg(sprintf("%s", name), tabs=depth, type="msg", LOG=FALSE)
        }
    }
    # grab all keys / names within this current / new env in order to scroll through them
    keys <- ls(env, all.names = TRUE)

    #cycle through them
    for (key in keys) {
        # pull the environment / variable
        value <- get(key, envir = env)

        # IF it is an environment then we are looking at recursion - call this function again and
        # scan through this new environment... set the depth as increased by 1...
        # given R's propensity to modify parent variables return from the function called depth - 1
        # which essentially resets the home depth to where it should be..
        if (is.environment(value)) {
            depth = print_env_dict(value, key, rootEnv, depth+1, includeData)
        }
    }

    # returning depth -1 just to keep track of the depth throughout the recursive call
    return (depth-1)
}
