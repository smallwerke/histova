#' Set an option / setting
#'
#' Function simply sets an option within the package. Run 'opt_print()' to get an overview of the
#' existing options. Mainly designed to allow for quick changes to the aesthetic settings for the
#' figure.
#'
#' @param envName name of the environment where the option is located
#' @param varName name of the variable to edit
#' @param varData data to set the variable to
#'
#' @returns Pass/Fail message
#' @export
#'
#' @examples
#' opt_set("fig", "X.Angle", 55)
opt_set <- function(envName, varName, varData) {

    # set auto
    set_env(the$Location.Dir, the$Location.File, the$Log.Save, env.new=FALSE, printMsg=FALSE)

    histova_msg(sprintf("Set Option"), type="title", LOG=TRUE)

    if ((exists(envName)) && (typeof(get(envName)) == "environment") && (exists(varName, envir=get(envName)))) {

        # update the variable's data, no checking of the supplied data is happening at this time
        if ( ( nchar(substr(toString(get(varName, envir=get(envName))), 0, 120)) +  nchar(substr(toString(varData), 0, 120)) )  > 100) {
            # two lines
            histova_msg(sprintf("Updating %s$%s\nfrom: %s\nto: %s", envName, varName, substr(toString(get(varName, envir=get(envName))), 0, 120), substr(toString(varData), 0, 120) ), LOG=TRUE)
        } else {
            # one line
            histova_msg(sprintf("Updating %s$%s from: %s -> to -> %s", envName, varName, substr(toString(get(varName, envir=get(envName))), 0, 120), substr(toString(varData), 0, 120) ), LOG=TRUE)
        }
        assign(varName, varData, envir=get(envName))

        if (is_con_open(the$LOG)) {
            close(the$LOG)
        }
        return("PASS")
    } else{
        histova_msg(sprintf("Either the environment (%s) or the variable name (%s) are incorrect. Run: \'opt_print(\"sum\")\' to get an overview.",
                            envName, varName), type="warn", LOG=TRUE)

        if (is_con_open(the$LOG)) {
            close(the$LOG)
        }
        return ("FAIL")
    }



}
