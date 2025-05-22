#' Print Settings
#'
#' This function simply prints out overview information about the loaded settings and data.
#' This includes data variable names AND group names for data. The data is printed out in a
#' tree / hierarchical format to demonstrate the organization of the settings
#'
#' @param envPrint the environment/s to print, send all to print everything
#'
#' @export
#'
#' @examples
#' print_settings("all")
print_settings <- function(envPrint = "all") {

    histova_msg(sprintf("Variables per Environment"), type="title", LOG=FALSE)

    # this will simply print a list of each recorded environment for this package AND
    # all of its variables in the nested format
    # build a vector to store the environments to print
    envList = c()
    # if 'all' is submitted then pull from the manually generated list of environments (from aaa.R)
    if ((length(envPrint) == 1) && (envPrint == "all")) {
        envList = the$envList
        histova_msg("Printing all environments used to save settings & data. Actual data isn't displayed in this, only the variable names", tabs=1, LOG=FALSE)
    # if a custom environment name/s are submitted then check each one to make sure it exists
    # before adding it to the list of environments, otherwise throw a warning and keep on moving
    } else {
        histova_msg("select environments submitted, checking to make sure each is valid...", tabs=1, LOG=FALSE)

        # if a single environment is submitted:
        if ((is.vector(envPrint)) && (length(envPrint) == 1)) {
            envPrint = c(envPrint)
        }
        # cycle through the vector to check and make sure each environment is valid, if not throw a warning
        for (envTest in envPrint) {
            if (envTest %in% the$envList) {
                envList = append(envList, c(envTest))
            } else {
                histova_msg(sprintf("submitted non existent environment name to print_settings (%s)", envTest), type="warn", LOG=FALSE)
            }
        }
    }
    histova_msg(sprintf("print out the following environments: '%s'", toString(envList)), tabs=1, LOG=FALSE)


    # create an environment to use for dynamically traversing the data...
    env_dict <- new.env(hash=TRUE)

    # the environment names that this package depends on are manually saved into a list in the file aaa.R
    # simply scroll through this list to get the environment names...
    #for (envName in the$envList) {
    for (envName in envList) {

        # create the root environment level which is simply the name of the corresponding environment
        # contained within the main recording dict 'env_dict'
        assign(envName, new.env(hash=TRUE), envir = env_dict)

        # get all of the names in the environment under study...
        # this includes all variables that contain their organization in a level1.level2... format
        env_vars <- rlang::env_names(get(envName))

        # scroll through all of the names within the root environment
        for (varName in env_vars) {
            # link to that current / root environment...
            # always need to reset otherwise it'll just ballon...
            current <- get(envName, envir = env_dict)

            # all setup variables are formated as follows: level1.level2.level3...
            # break them into a quick list using '.' to seperate the levels... the final level
            # will always be designated as the '-root_val' to indicate that it is the level that contains data
            varLevels <- unlist(strsplit(varName, "[.]"))

            # scroll through the levels in the variable and assign each level as a new environment
            # the final level gets a new entry that simply appends '-root_val' to the environment name
            # and this entry contains the complete variable name for reference
            for (i in 1:length(varLevels)) {
                # extract the key as a variable
                key <- varLevels[i]

                # provided this doesn't already exist & isn't an environment set a new environment following this key
                #if ((!exists(key, envir = current, inherits = FALSE)) || (!is.environment(get(key, envir = current)))) {
                if (!exists(key, envir = current, inherits = FALSE)) {
                    assign(key, new.env(hash = TRUE), envir = current)
                }

                # update the current environment to allow navigation through the tree...
                current <- get(key, envir = current)
            }

            # now that we are finished with the for loop through the levels it is safe to assume
            # that this is the outermost level and so another entry appended with '-root_val' is generated
            # that contains the actual variable name...
            assign(paste0(varLevels[length(varLevels)], "-root_val"), varName, envir = current)
        }
    }

    ############################
    # PRINT OUT TIME!!!!
    # time to cycle through and print out a nice nested list...
    # start - again - by scrolling through the manually saved environment list
    for (envName in envList) {

        # the root environment will be printed out as the base name
        histova_msg(sprintf("ENV: %s", envName), type="title", LOG=FALSE)
        #l = 1
        # get the envrionment being worked on
        current <- get(envName, envir=env_dict)

        #keys <- ls(current, all.names = TRUE)
        # this function will recursively scan through the entire environment 'dict'
        # and print out a nice little hierarchical tree...
        print_env_dict(current, envName, -1)
    }

    keys <- ls(env_dict, all.names = TRUE)
}
