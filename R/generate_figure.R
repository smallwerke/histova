#' Generate Figure
#'
#' @description putting it all together
#' set the directory and file location first and then call this function to run through the specified file
#'
#' @param location.dir The directory the data file is contained in
#' @param location.file The file containing the data
#'
#' @export
#'
#' @examples
#' generate_figure("/Users/Shared/HISTOVA_DATA", "test.txt")
generate_figure <- function(location.dir, location.file) {

    # consider adding some error checking here???
    the$Location.File = location.file
    the$Location.Dir = location.dir

    message("----------------  ----------------  ----------------")
    message("-------- Prep & Load config settings and data --------")

    # prep & load config info / data
    init_vars()
    load_file_head()
    load_data()

    message("-------- Statistical Analysis --------")

    # move onto stats analysis
    if (stats$Outlier != FALSE) { run_outlier() }
    run_stats_prep()

    # run actual tests
    if ("ANOVA" %in% stats$Test) { run_anova() }
    if ("STTest" %in% stats$Test) { run_sttest() }
    #if ("PTTest" %in% Stats.Test) { run_ttest(TRUE) } # NOT YET IMPLEMENTED!
}
