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

    # if a transformation is being conducted (eg treatment over control)
    # ** After a group is removed the ANOVA stats (if requested) are run again for ToverC **
    if (stats$Transform == "ToverC") {
        run_transform()
        # run the stats prep again to set the summary tables to the new values
        run_stats_prep()

        # remove the treatment group (it will be indicated by a line at 1)
        stats$group1Mute = stats$Transform.Treatment[1]
        fig$Plot.HLine = data.frame(y=c(1),size=c(1),color=c("black"))
    }

    # if the Y-values were adjusted (eg all divided by 1,000 - in run_stats_prep()) this will append the modification
    # to the end of your y-axis label - you can select one or two lines...
    if (is.numeric(fig$Y.Rig)) {
        if (fig$Y.Rig.Newline) {
            # Two Lines
            #Fig.Y = bquote(bold(atop(.(Fig.Y), "(" * .(Fig.Y.Supp[[1]]) * ")")))
            fig$Y = bquote(atop(.(fig$Y), "(" * .(fig$Y.Supp[[1]]) * ")"))
        } else {
            # Single Line
            fig$Y = bquote(.(fig$Y)~"("*.(fig$Y.Supp[[1]])*")")
        }
        # general math expression:
        #Fig.Y = bquote(.(Fig.Y)~"He"~r[xy]==~B^2)

        # following will successfully store the expression...
        #r = do.call(substitute, as.list(str2expression("r[xy]")))
        # error prone BUT it will parse a expression stored in a string...
        #Fig.Y = bquote(.(parse(text=Fig.Y)))
        # FULL list of current html4
        #"&Alpha;~&Beta;~&Gamma;~&Delta;~&Epsilon;~&Pi;~&Sigma;~&Tau;~&Phi;~&Omega;~&alpha;~&beta;~&gamma;~&delta;~&epsilon;~&pi;~&sigma;~&tau;~&phi;~&omega;~&bull;~&isin;~&notin;~&radic;~&infin;~&asymp;~&micro;"

        #assign("Fig.Y", Fig.Y, envir = .GlobalEnv) ### CHANGED - no longer needed ###
    }
}
