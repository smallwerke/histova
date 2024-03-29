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
        stats$Group1.Mute = stats$Transform.Treatment[1]
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

    # this may not be 100% necessary if the
    # the t-tests should be run on the remaining groups POST transformation
    # but BEFORE removal of the control group
    if (stats$Transform == "ToverC") {
        if ("STTest" %in% stats$Test) { run_sttest() }
        #if ("PTTest" %in% Stats.Test) { run_ttest(TRUE) }
    }

    # remove a group from being displayed (eg for treatment / control figures)
    if ((stats$Group1.Mute != FALSE) && (stats$Anova.Group2 == FALSE)) {

        warning(sprintf("group1Mute is set to %s, attempting to remove this group! (file: %s)", stats$Group1.Mute, the$Location.File))

        raw$base = subset(raw$base, Group1!=stats$Group1.Mute)
        raw$base[] = lapply(raw$base, function(x) if(is.factor(x)) factor(x) else x)
        #assign("raw", raw, envir = .GlobalEnv) ### CHANGED - no longer needed ###

        raw$summary = subset(raw$summary, Group1!=stats$Group1.Mute)
        raw$summary[] = lapply(raw$summary, function(x) if(is.factor(x)) factor(x) else x)
        #assign("raw.summary", raw.summary, envir = .GlobalEnv) ### CHANGED - no longer needed ###

        raw$summary.multi = subset(raw$summary.multi, Group1!=stats$Group1.Mute)
        raw$summary.multi[] = lapply(raw$summary.multi, function(x) if(is.factor(x)) factor(x) else x)
        #assign("raw.summary.multi", raw.summary.multi, envir = .GlobalEnv) ### CHANGED - no longer needed ###
    }

    # the ANOVA test should be run on the remaining groups POST transformation
    if (stats$Transform == "ToverC") {
        if ("ANOVA" %in% stats$Test) { run_anova() }
        # following vars are set in run_anova() (raw.anova.multi, raw.aov.multi, raw.aov.tukey.multi)
    }

    message("-------- Build Histogram --------")
    set_aesthetics()
    build_histo()

    # add a line to the figure...
    if (is.na(fig$Plot.HLine$y[1]) != TRUE) {
        for (HL in 1:nrow(fig$Plot.HLine)) {
            message(sprintf("adding a horizontal line to the figure at: \'%s\'", fig$Plot.HLine$y[HL]))
            the$gplot = the$gplot + ggplot2::geom_hline(yintercept=fig$Plot.HLine$y[HL], linetype="solid", color=fig$Plot.HLine$color[HL], linewidth=fig$Plot.HLine$size[HL])
        }
    }

    # print out the plot for viewing in RStudio - probably good idea to make this an optional setting...
    print(the$gplot)

    # save the image to the working directory using the modified txt filename - this WILL
    # overwrite an existing image...
    the$Location.Image = paste0(the$Location.Dir, "/", sub("txt", fig$Save.Type, the$Location.File))
    message(sprintf("saving your new figure to: \'%s\'", the$Location.Image))
    message("-------- SAVE Histogram --------")

    # implement cairo package to better embed fonts into the output
    if (fig$Save.Type %in% c("tex", "svg")) {
        ggplot2::ggsave(the$Location.Image, width = fig$Save.Width, height = fig$Save.Height, dpi = fig$Save.DPI, units = fig$Save.Units, device = fig$Save.Type, limitsize = FALSE)
    } else if (fig$Save.Type == "pdf") {
        ggplot2::ggsave(the$Location.Image, width = fig$Save.Width, height = fig$Save.Height, dpi = fig$Save.DPI, units = fig$Save.Units, device = grDevices::cairo_pdf, limitsize = FALSE)
    } else {
        ggplot2::ggsave(the$Location.Image, width = fig$Save.Width, height = fig$Save.Height, dpi = fig$Save.DPI, units = fig$Save.Units, device = fig$Save.Type, type="cairo", limitsize = FALSE)
    }
    message("----------------  ----------------  ----------------")

}
