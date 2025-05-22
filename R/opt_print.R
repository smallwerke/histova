#' Print Options & Settings
#'
#' This function simply prints out overview information about the loaded settings and data.
#' This includes data variable names AND group names for data. The data is printed out in a
#' tree / hierarchical format to demonstrate the organization of the settings.
#'
#' There are three ways to use this function. Sending in the string "all" will print out all
#' environments and their variable names. "sum" will only print the environment names and a list
#' of the variables for each environment. Can also send a name or vector of names for the environments
#' that you want to print out. If an environment isn't found a warning will be sent.
#'
#' If you want the complete data contained within a variable specify the environment name 'envPrint'
#' followed by variable 'varDump' you want the entire data for.
#'
#' @param envPrint the environment/s to print, send all to print everything, sum to print env overview
#' @param varDump the full name of the variable if you want a complete printout of the data
#' @param includeData T/F if the beginning of the data should be included
#'
#' @export
#'
#' @examples
#' opt_print("all")
opt_print <- function(envPrint = "all", varDump = NULL, includeData = TRUE) {

    histova_msg(sprintf("Variables per Environment"), type="title", LOG=FALSE)

    # build a vector to store the environments to print
    envList <- c()

    # IF a variable is specified to do a comprehensive dump from set the envList & envPrint
    # to NULL to skip the rest of the function...
    if (!is.null(varDump)) {

        if ((exists(envPrint)) && (exists(varDump, envir=get(envPrint)))) {
            histova_msg(sprintf("Env: %s", envPrint), type="head", LOG=FALSE)
            histova_msg(sprintf("Var: %s", varDump), type="head", LOG=FALSE)
            histova_msg(sprintf("Data:"), type="head", LOG=FALSE)

            # pull the data:
            varDumpData = get(varDump, envir=get(envPrint))
            histova_msg(sprintf("%s", toString(varDumpData)), type="msg", LOG=FALSE)

            # setting the following to null will skip over the rest fo the function...
            envPrint <- NULL
            envList <- NULL

        } else {
            histova_msg(sprintf("Either the variable (%s) or the environment (%s) you supplied DO NOT EXIST\n\tswitching to: \'opt_print(\"sum\")\' for an overview of existing environments & variables!",
                                varDump, envPrint), type="warn", LOG=FALSE)

            envPrint <- "sum"
            varDump <- NULL
        }

    }

    # this will simply print a list of each recorded environment for this package AND
    # all of its variables in the nested format
    # if 'all' is submitted then pull from the manually generated list of environments (from aaa.R)
    if ((length(envPrint) == 1) && (envPrint == "all")) {
        envList <- the$envList
        histova_msg("Printing all environments used to save settings & data. Actual data isn't displayed in this, only the variable names", tabs=1, LOG=FALSE)
    } else if ((length(envPrint) == 1) && (envPrint == "sum")) {
        envList <- NULL

        for (envName in the$envList) {
            # the root environment will be printed out as the base name
            histova_msg(sprintf("ENV: %s", envName), type="title", LOG=FALSE)
            # get the envrionment to summarize
            rootEnv <- get(envName)

            # dumps the content / names of the environment being examined...
            histova_msg(sprintf("CONTENTS OF ENV: %s", toString(names(rootEnv))), LOG=FALSE)
        }
    # if a custom environment name/s are submitted then check each one to make sure it exists
    # before adding it to the list of environments, otherwise throw a warning and keep on moving
    } else if (!is.null(envPrint)) {
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
    if (!is.null(envList)) {
        histova_msg(sprintf("print out the following environments: '%s'", toString(envList)), tabs=1, LOG=FALSE)
        if (includeData) {
            histova_msg("Data summary (first 40 characters) will be printed for each listed variable.", tabs=1, LOG=FALSE)
        } else {
            histova_msg("SKIPPING DATA SUMMARY", tabs=1, LOG=FALSE)
        }
    }


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

        # get the envrionment being worked on
        current <- get(envName, envir=env_dict)
        rootEnv <- get(envName)

        #keys <- ls(current, all.names = TRUE)
        # this function will recursively scan through the entire environment 'dict'
        # and print out a nice little hierarchical tree...
        opt_print_env_dict(current, envName, rootEnv, -1, includeData)
    }
}
