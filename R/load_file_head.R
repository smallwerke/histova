#' Load File Head
#'
#' @description Load the configuration from the head of the file specified in the$Location.file
#'
#' @export
#'
#' @examples
#' load_file_head()
load_file_head = function() {

    message(sprintf("---- Load config (file: %s)", the$Location.File))

    # doesn't like when packages change the working directory...
    # drop this approach and generate a fullPath var instead to open a file connection
    #getwd()
    #setwd(the$Location.Dir)
    #getwd()
    fullPath = paste0(the$Location.Dir, "/", the$Location.File)

    # forced reset
    init_vars()

    # set the override placeholder to NULL
    Override.tmp = NULL
    Fig.Y.tmp = NULL

    # read in the comments and set any specified variables (title, legend, etc)
    CON = file(fullPath, open = "r")
    l = readLines(CON, 1)
    while(substring(l, 1, 1) == '#') {
        #message(sprintf("---- Load data (line: %s)", l))

        # pull out the information
        lA = strsplit(substring(l, 2), "\t");

        # if the line is a comment skip to the next iteration
        if (substring(l, 2, 2) == '#') {
            l = readLines(CON, 1);
            next
        } else {
            l = readLines(CON, 1);
        }

        # maintain backwards compatibility - simply move this to a new line for analysis...
        if (lA[[1]][1] == "Stats STTest Pairs") { lA[[1]] = c("Stats Test", "STTest", lA[[1]][-1]) }
        else if (lA[[1]][1] == "Stats PTTest Pairs") { lA[[1]] = c("Stats Test", "PTTest", lA[[1]][-1]) }

        ################ OVERRIDE? ################
        if (lA[[1]][1] == "Override") {
            if (lA[[1]][2] %in% c("TRUE", "True", "true", "1")) {
                if (isTRUE(the$Override)) { message("turning override ON AND overwriting previous override!!") }
                else { message("turning override ON!!") }

                # set override to true from here on out
                Override.tmp <- TRUE
                # turn off override protection if it was set
                the$Override <- FALSE
                # set all variables back to their default before moving on
                message("resetting variables to defaults BEFORE loading config")
                init_vars()
            } else if (lA[[1]][2] %in% c("FALSE", "False", "false", "0")) {
                message("turning override OFF!")
                the$Override <- FALSE
                message("resetting variables to defaults BEFORE loading config")
                init_vars()
            }
        }

    } # while(substring(l, 1, 1) == '#') {
    close(CON)

}
